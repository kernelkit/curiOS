<a href="https://www.flaticon.com/free-icons/docker"><img align="right" src="doc/container.png" width="200px" alt="Docker icons created by pocike - Flaticon"></a>

# curiOS — a slim curated container OS

curiOS, pronounced curious, is a project by the [same team][8] of developers
that created and maintain the [Infix operating system][7].  If you like the
idea of modeling an entire OS with YANG, have a look at Infix.

This project provides a set of *defconfigs* for 64-bit ARM and x86 systems
that can be used with Infix or any other [OCI](https://opencontainers.org/)
compatible runtime.

> [!NOTE]
> The system container is very useful for staging/development before deploying
> any of the slim application containers, because they can be very difficult
> to debug (none or little tooling in image).

## AppStore

The [KernelKit AppStore][2] on GHCR provides the following pre-built images.

### [curiOS system][3]

An example system container, shows how to run multiple services.  Comes with
the following services and tools:

- BusyBox (full configuration)
- Dropbear SSH daemon
- mini-snmpd
- netopeer-cli
- nftables
- ntpd

See this blog post on how to use this container with Infix:

- [Infix Advanced Container Networking](https://kernelkit.org/posts/advanced-containers/)

### [curiOS ntpd][4]

This container is only `ntpd`, started by `tini` with `-n -g` flags.  The
default configuration file is `/etc/ntp.conf`, see `doc/` for a sample.  To
override use a mount or volume, and remember to also set up a volume for the
`/var` or `/var/lib` directory to let the daemon save drift data.

ISC ntpd supports [multicasting NTP][10] to a subnet.  For more information
see the [official ntpd site](https://www.ntp.org/).

### [curiOS nftables][5]

Useful for advanced netfilter setups when the container runs in host network
mode.  At startup it loads `/etc/nftables.conf` and then waits for a signal.
At shutdown `nft flush ruleset` is called.

This container comes with a minimal set of BusyBox tools, including a shell,
so the `nftables.conf` file can be modified from inside the container (vi).
Although the most common use-case is to mount a file from the host system.
See `doc/` for two samples: end-device and home router.

See this blog post on how to use this container with Infix:

- [Infix w/ WAN+LAN firewall setup](https://kernelkit.org/posts/firewall-container/)

### [curiOS httpd][6]

Tiny web server container based on BusyBox httpd, suitable for embedding in a
firmware image as an example container.

The server looks for `/var/www/index.html`, so use a volume on `/var/www` to
change the default web page.

With a custom command you can also change the default command line, e.g, to
run in foreground, with verbose mode, on port 8080:

- `/usr/sbin/httpd -f -v -p 8080`

For more help, see the [BusyBox docs](https://busybox.net/downloads/BusyBox.html#httpd)

## Origin & References

curiOS is a wrapper around [Buildroot][0] for creating container images for
uploading to Docker Hub or similar.  Buildroot is an SDK for building embedded
Linux distributions.  It handles the removal of man pages, shared files, and
many pieces not germane to running on an embedded platform, and, as it turns
out, containers.

curiOS is a fork of <https://github.com/brianredbeard/coreos_buildroot>

[0]: https://buildroot.org
[1]: https://busybox.net
[2]: https://github.com/orgs/kernelkit/packages?repo_name=curiOS
[3]: https://github.com/orgs/kernelkit/packages/container/package/curios
[4]: https://github.com/orgs/kernelkit/packages/container/package/curios-ntpd
[5]: https://github.com/orgs/kernelkit/packages/container/package/curios-nftables
[6]: https://github.com/orgs/kernelkit/packages/container/package/curios-httpd
[7]: https://github.com/kernelkit/infix
[8]: https://kernelkit.org
[10]: https://www.ntp.org/documentation/4.2.8-series/discover/
