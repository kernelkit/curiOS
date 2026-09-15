/* SPDX-License-Identifier: ISC
 *
 * curios-health -- container health probe
 *
 * Container health checks are usually a shell one-liner, but the
 * slimmest curiOS images have no shell, and the ISC ntp query tools
 * exit 0 even when they cannot reach the daemon.  This probes the
 * kernel directly instead: a service that holds the socket it is
 * supposed to hold is up.
 *
 * Deliberately free of stdio.  Linked statically against uClibc, the
 * printf and scanf machinery costs ~100 kB, which is a third of the
 * image this is meant to be watching.
 */
#include <fcntl.h>
#include <dirent.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define TCP_LISTEN 0x0A
#define BUFSZ      8192

static int quiet;

static void say(const char *str)
{
	if (quiet)
		return;
	/* Nothing useful to do if the diagnostic itself fails. */
	ssize_t ign = write(STDERR_FILENO, str, strlen(str));
	(void)ign;
}

static void sayln(const char *pfx, const char *str)
{
	say(pfx);
	say(str);
	say("\n");
}

static int hexval(char ch)
{
	if (ch >= '0' && ch <= '9')
		return ch - '0';
	if (ch >= 'a' && ch <= 'f')
		return ch - 'a' + 10;
	if (ch >= 'A' && ch <= 'F')
		return ch - 'A' + 10;
	return -1;
}

static const char *skip_blank(const char *p)
{
	while (*p == ' ' || *p == '\t')
		p++;
	return p;
}

static const char *skip_field(const char *p)
{
	while (*p && *p != ' ' && *p != '\t')
		p++;
	return skip_blank(p);
}

static long parse_hex(const char *p, const char **end)
{
	long val = 0;
	int digit;

	while ((digit = hexval(*p)) >= 0) {
		val = val * 16 + digit;
		p++;
	}
	if (end)
		*end = p;

	return val;
}

/*
 * /proc/net/{tcp,udp}{,6} share a layout:
 *
 *  sl  local_address rem_address st ...
 *   0: 00000000:0016 00000000:0000 0A ...
 *
 * so the port is the hex after the colon of field two, and the state is
 * field four.  Listening TCP is 0A; a bound UDP socket has no
 * equivalent, its presence in the table is the answer.
 */
static int scan_line(const char *line, long port, int want_listen)
{
	const char *p = skip_blank(line);
	long lport, state;

	p = skip_field(p);		/* sl */
	if (!*p)
		return 0;

	/* local_address is addr:port, we only care about the port */
	while (*p && *p != ':' && *p != ' ')
		p++;
	if (*p != ':')
		return 0;
	p++;

	lport = parse_hex(p, &p);
	if (lport != port)
		return 0;

	p = skip_blank(p);
	p = skip_field(p);		/* rem_address */
	if (!*p)
		return 0;

	state = parse_hex(p, NULL);

	return !want_listen || state == TCP_LISTEN;
}

static int scan_file(const char *file, long port, int want_listen)
{
	char buf[BUFSZ], line[512];
	size_t len = 0;
	int fd, hit = 0;
	ssize_t num;

	fd = open(file, O_RDONLY);
	if (fd < 0)
		return 0;

	while (!hit && (num = read(fd, buf, sizeof(buf))) > 0) {
		ssize_t i;

		for (i = 0; i < num; i++) {
			if (buf[i] != '\n') {
				if (len < sizeof(line) - 1)
					line[len++] = buf[i];
				continue;
			}

			line[len] = 0;
			len = 0;
			if (scan_line(line, port, want_listen)) {
				hit = 1;
				break;
			}
		}
	}

	close(fd);
	return hit;
}

static int portcheck(const char *proto, long port)
{
	char v4[32], v6[32];
	int listen;

	listen = !strcmp(proto, "tcp");
	strcpy(v4, "/proc/net/");
	strcat(v4, proto);
	strcpy(v6, v4);
	strcat(v6, "6");

	return scan_file(v4, port, listen) || scan_file(v6, port, listen);
}

static int proccheck(const char *name)
{
	struct dirent *d;
	int hit = 0;
	DIR *dir;

	dir = opendir("/proc");
	if (!dir)
		return 0;

	while (!hit && (d = readdir(dir))) {
		char path[286], comm[128];
		ssize_t num;
		int fd;

		if (d->d_name[0] < '0' || d->d_name[0] > '9')
			continue;

		strcpy(path, "/proc/");
		strncat(path, d->d_name, sizeof(path) - 20);
		strcat(path, "/comm");

		fd = open(path, O_RDONLY);
		if (fd < 0)
			continue;

		num = read(fd, comm, sizeof(comm) - 1);
		close(fd);
		if (num <= 0)
			continue;

		if (comm[num - 1] == '\n')
			num--;
		comm[num] = 0;

		if (!strcmp(comm, name))
			hit = 1;
	}

	closedir(dir);
	return hit;
}

static int usage(int rc)
{
	static const char help[] =
		"Usage: curios-health [-q] CHECK [CHECK ...]\n"
		"\n"
		"Exits 0 when every CHECK passes, 1 otherwise.\n"
		"\n"
		"Checks:\n"
		"  tcp:PORT    a socket is listening on TCP PORT\n"
		"  udp:PORT    a socket is bound to UDP PORT\n"
		"  proc:NAME   a process named NAME is running\n"
		"  file:PATH   PATH exists\n"
		"\n"
		"Options:\n"
		"  -q          say nothing, report only via exit status\n";
	int fd = rc ? STDERR_FILENO : STDOUT_FILENO;

	ssize_t ign = write(fd, help, sizeof(help) - 1);

	(void)ign;

	return rc;
}

static int check(const char *spec)
{
	const char *arg;
	int ok;

	arg = strchr(spec, ':');
	if (!arg) {
		sayln("curios-health: malformed check ", spec);
		return 0;
	}
	arg++;

	if (!strncmp(spec, "tcp:", 4))
		ok = portcheck("tcp", strtol(arg, NULL, 0));
	else if (!strncmp(spec, "udp:", 4))
		ok = portcheck("udp", strtol(arg, NULL, 0));
	else if (!strncmp(spec, "proc:", 5))
		ok = proccheck(arg);
	else if (!strncmp(spec, "file:", 5))
		ok = access(arg, F_OK) == 0;
	else {
		sayln("curios-health: unknown check ", spec);
		return 0;
	}

	if (!ok)
		sayln("curios-health: FAILED ", spec);

	return ok;
}

int main(int argc, char *argv[])
{
	int i, rc = 0;

	if (argc > 1 && !strcmp(argv[1], "-q")) {
		quiet = 1;
		argc--;
		argv++;
	}

	if (argc < 2)
		return usage(1);

	if (!strcmp(argv[1], "-h") || !strcmp(argv[1], "--help"))
		return usage(0);

	for (i = 1; i < argc; i++) {
		if (!check(argv[i]))
			rc = 1;
	}

	return rc;
}
