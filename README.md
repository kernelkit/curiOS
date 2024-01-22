# curiOS — a slim curated container OS

curiOS, pronounced curious, is a slim curated base of system containers.

curiOS is a wrapper around [Buildroot][0] for creating container images for
uploading to Docker Hub or similar.  Buildroot is an SDK for building embedded
Linux distributions.  It handles the removal of man pages, shared files, and
many pieces not germane to running on an embedded platform, and, as it turns
out, containers.


## AppStore

The [KernelKit AppStore][2] on GHCR provides the following readily available
container images for both AMD64 and ARM64 hosts:

 - [curiOS system][3]: Dropbear SSH daemon, mini-snmpd, netopeer-cli
 - [curiOS ntpd][4]: ISC ntpd supports [multicasting NTP][10] to a subnet
 - [curiOS nftables][5]: Set up advanced netfilter rules

> All images contain the same [BusyBox][1] toolset.


## Origin & References

curiOS is a fork of https://github.com/brianredbeard/coreos_buildroot

[0]: https://buildroot.org
[1]: https://busybox.net
[2]: https://github.com/orgs/kernelkit/packages?repo_name=curiOS
[3]: https://github.com/orgs/kernelkit/packages/container/package/curios
[4]: https://github.com/orgs/kernelkit/packages/container/package/curios-ntpd
[5]: https://github.com/orgs/kernelkit/packages/container/package/curios-nftables
[10]: https://www.ntp.org/documentation/4.2.8-series/discover/
