<a href="https://www.flaticon.com/free-icons/docker"><img align="right" src="doc/container.png" width="200px" alt="Docker icons created by pocike - Flaticon"></a>

# curiOS — Production-Ready Container Images for Embedded Systems

**Lightweight • Secure • Purpose-Built**

curiOS delivers ultra-slim, curated container images optimized for
embedded and edge computing.  Built on battle-tested [Buildroot][0],
each image is stripped of unnecessary components while maintaining full
functionality.

## Why curiOS?

✨ **Ultra-minimal footprint** - Images as small as 270KB  
🔒 **Security-first** - No unnecessary packages or attack surface  
⚡ **Fast deployment** - Lightning-quick startup times for edge applications  
🎯 **Purpose-built** - Each container does one thing exceptionally well  
🔧 **Developer-friendly** - Easy integration with existing workflows  

## Perfect For

- **IoT Gateways** - Lightweight network services and protocols
- **Edge Computing** - Minimal resource consumption at the edge  
- **Container Orchestration** - Kubernetes, Docker Swarm, and more
- **Development Staging** - Debug and test before production deployment
- **Embedded Firewalls** - Advanced netfilter configurations in containers

> [!TIP]
> The system container includes full BusyBox tooling, making it perfect
> for staging and development before deploying the ultra-slim
> application containers.

---

*curiOS is brought to you by the [same team][8] that created and
maintains the [Infix operating system][7]. If you like the idea of
modeling an entire OS with YANG, check out Infix!*

## Ready-to-Use Images

Get started instantly with our pre-built images available on the
[KernelKit Container Registry][2]. Each image is continuously built and
tested for ARM64 and x86-64 architectures.

### [curiOS system][3] 🖥️

**Full-featured development and staging environment** - Perfect for
prototyping and debugging before deploying specialized
containers. Includes everything you need:

- **BusyBox** (complete toolset) - Full UNIX utilities
- **Dropbear SSH** - Secure remote access
- **mini-snmpd** - Network monitoring
- **netopeer-cli** - NETCONF client
- **nftables** - Advanced firewall
- **ntpd** - Network time synchronization

See this blog post on how to use this container with Infix:

- [Infix Advanced Container Networking](https://kernelkit.org/posts/advanced-containers/)

### [curiOS ntpd][4] ⏰

**Precision time synchronization** (~400KB) - Ultra-lightweight NTP
daemon for accurate timekeeping across your infrastructure. Features:

- **ISC ntpd** with `-n -g` flags for quick sync
- **Multicast NTP** support for subnet-wide time distribution  
- **Persistent drift** data via `/var/lib` volume mount
- **Custom config** support - mount your own `/etc/ntp.conf`

Perfect for IoT devices and distributed systems requiring precise
time. See the [official ntpd documentation](https://www.ntp.org/) for
advanced configuration.

### [curiOS nftables][5] 🔥

**Advanced containerized firewall** (~670KB) - Production-ready
netfilter management with zero-downtime rule updates. Features:

- **Host network mode** support for transparent firewalling
- **Graceful startup/shutdown** - Loads rules on start, flushes on stop
- **Live configuration** - Built-in vi editor for rule modifications
- **Mount-friendly** - Use host-based config files via volumes
- **Sample configurations** included for end-devices and routers

Ideal for edge devices, containers-as-firewalls, and advanced network policies.

See this blog post on how to use this container with Infix:

- [Infix w/ WAN+LAN firewall setup](https://kernelkit.org/posts/firewall-container/)

### [curiOS httpd][6] 🌐

**Ultra-lightweight web server** (~270KB) - The smallest possible HTTP
server for embedded applications and IoT devices. Features:

- **Minimal footprint** - Perfect for resource-constrained environments
- **Volume support** - Mount your content to `/var/www/`
- **Flexible configuration** - Customizable ports, logging, and behavior
- **Firmware-ready** - Ideal for embedding in device firmware

**Example usage:**

```bash
# Custom port and verbose logging
docker run -p 8080:8080 ghcr.io/kernelkit/curios-httpd /usr/sbin/httpd -f -v -p 8080
```

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
