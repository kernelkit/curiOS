EXEC    = curios-health
OBJS    = main.o
CFLAGS ?= -W -Wall -Wextra -Os
prefix ?= /usr
libexecdir ?= $(prefix)/libexec/curios

all: $(EXEC)

$(EXEC): $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(OBJS)

install: $(EXEC)
	install -d $(DESTDIR)$(libexecdir)
	install -m 0755 $(EXEC) $(DESTDIR)$(libexecdir)/$(EXEC)

clean:
	-rm -f $(EXEC) $(OBJS)

.PHONY: all install clean
