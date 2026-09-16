Running curiOS on Infix
=======================

[Infix][0] runs containers under podman and configures them in YANG, so
a curiOS container is a few lines of `startup-config` rather than a unit
file and a wrapper script.  These are working recipes to paste into the
CLI.

None of this is required to use curiOS — the images are ordinary OCI
images.  It is here because the combination does something no other
platform can: hand a container a *physical switch port*.

> [!TIP]
> Build the configuration in the CLI, then extract the XML with
> `cfg -X` from the shell to keep it under version control.


Firewall on a physical port
---------------------------

Infix uses switchdev, so `e1` below is a real front-panel port, moved
into the container's network namespace.  Not a veth pair into a bridge —
the port itself.

    admin@example:/> configure
    admin@example:/config/> edit interface e1
    admin@example:/config/interface/e1/> set container-network
    admin@example:/config/interface/e1/> end
    admin@example:/config/> edit container fw
    admin@example:/config/container/fw/> set image docker://ghcr.io/kernelkit/curios-nftables:latest
    admin@example:/config/container/fw/> set network interface e1
    admin@example:/config/container/fw/> set capabilities add net_admin
    admin@example:/config/container/fw/> set capabilities add net_raw
    admin@example:/config/container/fw/> set env ENABLE_INTERFACES value e1
    admin@example:/config/container/fw/> set mount nftables.conf target /etc/nftables.conf
    admin@example:/config/container/fw/> leave

The ruleset travels with the configuration as a content mount, so it is
part of `startup-config` and survives a factory reset of everything else.
See [nftables.conf.sample](../nftables.conf.sample) and
[nftables-router.conf.sample](../nftables-router.conf.sample).


Time server on a container bridge
---------------------------------

    admin@example:/> configure
    admin@example:/config/> edit interface docker0
    admin@example:/config/interface/docker0/> set container-network
    admin@example:/config/interface/docker0/> end
    admin@example:/config/> edit container ntpd
    admin@example:/config/container/ntpd/> set image docker://ghcr.io/kernelkit/curios-ntpd:latest
    admin@example:/config/container/ntpd/> set network interface docker0
    admin@example:/config/container/ntpd/> set network publish 123:123/udp
    admin@example:/config/container/ntpd/> set capabilities add sys_time
    admin@example:/config/container/ntpd/> set volume drift target /var/lib
    admin@example:/config/container/ntpd/> set mount ntp.conf target /etc/ntp.conf
    admin@example:/config/container/ntpd/> leave

The volume keeps the drift file across restarts and image upgrades.  See
[ntp.conf.sample](../ntp.conf.sample).


Web server
----------

    admin@example:/> configure
    admin@example:/config/> edit container web
    admin@example:/config/container/web/> set image docker://ghcr.io/kernelkit/curios-httpd:latest
    admin@example:/config/container/web/> set network interface docker0
    admin@example:/config/container/web/> set network publish 8080:80
    admin@example:/config/container/web/> set volume www target /var/www
    admin@example:/config/container/web/> leave


Staging and debugging
---------------------

When something is wrong on a device rather than on your desk, the system
container has the tools — tcpdump, nftables, netopeer2-cli, ntpq,
mcjoin, mping — without installing anything on the host:

    admin@example:/> container run ghcr.io/kernelkit/curios:latest

Use `Ctrl-p Ctrl-q` to detach.


Health
------

Each service image declares a `HEALTHCHECK`, so podman tracks it without
further configuration:

    admin@example:/> show container

[0]: https://github.com/kernelkit/infix
