<a href="https://www.flaticon.com/free-icons/container"><img align="right" src="doc/container.png" width="200px" alt="Container icons created by smashingstocks - Flaticon"></a>

# curiOS -- a slim curated container OS

curiOS, pronounced curious, is a slim curated base of containers.


## AppStore

The [KernelKit AppStore][2] on GHCR provides the following readily available
container images for both AMD64 and ARM64 hosts:

 - [curiOS system][3]: A system container, example of how to run multiple
   services: Dropbear SSH daemon, mini-snmpd, netopeer-cli, ntpd, nftables
 - [curiOS ntpd][4]: ISC ntpd supports [multicasting NTP][10] to a subnet
 - [curiOS nftables][5]: Useful for advanced netfilter setups.  At startup
   loads `/etc/netfilter.conf` and calls `nft flush ruleset` at shutdown
 - [curiOS httpd][6]: Tiny web server container based on BusyBox httpd,
   suitable for embedding in a firmware image as an example container

> **Note:** the system container is very useful for staging/development
> before deploying any of the slim application containers, because they
> can be very difficult to debug (none or little tooling in image).


## Origin & References

curiOS is a wrapper around [Buildroot][0] for creating container images for
uploading to Docker Hub or similar.  Buildroot is an SDK for building embedded
Linux distributions.  It handles the removal of man pages, shared files, and
many pieces not germane to running on an embedded platform, and, as it turns
out, containers.

curiOS is a fork of https://github.com/brianredbeard/coreos_buildroot

[0]: https://buildroot.org
[1]: https://busybox.net
[2]: https://github.com/orgs/kernelkit/packages?repo_name=curiOS
[3]: https://github.com/orgs/kernelkit/packages/container/package/curios
[4]: https://github.com/orgs/kernelkit/packages/container/package/curios-ntpd
[5]: https://github.com/orgs/kernelkit/packages/container/package/curios-nftables
[6]: https://github.com/orgs/kernelkit/packages/container/package/curios-httpd
[10]: https://www.ntp.org/documentation/4.2.8-series/discover/
