<a href="https://www.flaticon.com/free-icons/docker"><img align="right" src="doc/container.png" width="200px" alt="Docker icons created by pocike - Flaticon"></a>

# curiOS — slim, curated containers

[![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)
[![GitHub Release](https://img.shields.io/github/v/release/kernelkit/curiOS)](https://github.com/kernelkit/curiOS/releases)

**Lightweight • Secure • Purpose-Built**

*curiOS* delivers ultra-slim, curated container images optimized for
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

*curiOS is brought to you by the [same team][9] that created and
maintains the [Infix operating system][8]. If you like the idea of
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
- **Interface management** - Automatically bring up/down interfaces via `ENABLE_INTERFACES`

Ideal for edge devices, containers-as-firewalls, and advanced network policies.

**Environment variables:**

- `ENABLE_INTERFACES` - Space-separated list of network interfaces
  (e.g., `"e1 e24"`) to bring up on startup, after the firewall rules
  have been applied, and take down on shutdown before disabling the
  firewall

**Example usage:**

```bash
# Start with automatic interface management
docker run --network=host -e ENABLE_INTERFACES="e1 e24" \
  -v /path/to/nftables.conf:/etc/nftables.conf:ro \
  ghcr.io/kernelkit/curios-nftables:latest
```

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
docker run -p 8080:8080 ghcr.io/kernelkit/curios-httpd:latest /usr/sbin/httpd -f -v -p 8080
```

For more help, see the [BusyBox docs](https://busybox.net/downloads/BusyBox.html#httpd)

### [curiOS neofetch][7] 🖼️

**System information at a glance** (~750KB) - Perfect for demos, system
monitoring, and showing off your container infrastructure. Features:

- **Beautiful ASCII art** - Eye-catching system logos and information display
- **Comprehensive details** - OS, kernel, uptime, memory, CPU, and more
- **Container-optimized** - Shows host system info even when containerized
- **Demo-ready** - Perfect for presentations and system showcases

**Example usage:**

```bash
# Simple system info display
docker run --rm ghcr.io/kernelkit/curios-neofetch:latest

# With host system access for accurate info
docker run --rm -v /etc/os-release:/etc/os-release:ro ghcr.io/kernelkit/curios-neofetch:latest

# Get a shell instead
docker run --rm -i -t --entrypoint /bin/bash ghcr.io/kernelkit/curios-neofetch:latest
```

## Getting Images

### From Container Registry

The easiest way to use curiOS is pulling pre-built images from the
[KernelKit Container Registry][2]:

```bash
# Pull the latest stable release
docker pull ghcr.io/kernelkit/curios-nftables:latest

# Or pull a specific version
docker pull ghcr.io/kernelkit/curios-nftables:1.2.3

# Or pull the bleeding edge
docker pull ghcr.io/kernelkit/curios-nftables:edge
```

### From Release Tarballs

Alternatively, download OCI tarballs from [GitHub Releases](https://github.com/kernelkit/curiOS/releases)
and load them with `podman` or `docker`:

```bash
# Download release tarball
wget https://github.com/kernelkit/curiOS/releases/download/v1.2.3/curios-nftables-oci-amd64-v1.2.3.tar.gz

# Extract and load with podman
tar xzf curios-nftables-oci-amd64-v1.2.3.tar.gz
cd curios-nftables-oci-amd64-v1.2.3
podman load < index.json

# Or with docker
docker load < index.json
```

This method is useful for air-gapped environments or when you want to verify
the tarball checksum before loading.

## Building from Source

curiOS uses [Buildroot][0] as its build system. To build a container from source:

### Prerequisites

- Linux build system (Ubuntu, Debian, Fedora, etc.)
- Standard development tools: `gcc`, `make`, `git`
- At least 4GB of free disk space

### Build Steps

```bash
# Clone the repository
git clone https://github.com/kernelkit/curiOS.git
cd curiOS
git submodule update --init --recursive

# Configure for your target (e.g., nftables for amd64)
make nftables_amd64_defconfig

# Build (this will take a while on first run)
make

# The resulting OCI image will be in output/images/
cd output/images
ls -lh rootfs-oci/

# Load into podman or docker
podman load < rootfs-oci
```

### Available Containers

You can build any of these containers by replacing `nftables` in the commands above:

- `system` - Full-featured development environment
- `ntpd` - NTP time synchronization
- `nftables` - Firewall container
- `httpd` - Lightweight web server
- `neofetch` - System information display

Each container supports both `amd64` and `arm64` architectures (e.g.,
`nftables_amd64_defconfig` or `nftables_arm64_defconfig`).

### Customizing Containers

To customize a container:

1. Start with an existing defconfig: `make nftables_amd64_defconfig`
2. Modify the configuration: `make menuconfig`
3. Save your changes: `make savedefconfig`
4. Build: `make`

For more details, see [CONTRIBUTING.md](.github/CONTRIBUTING.md).

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
[7]: https://github.com/orgs/kernelkit/packages/container/package/curios-neofetch
[8]: https://github.com/kernelkit/infix
[9]: https://kernelkit.org
[10]: https://www.ntp.org/documentation/4.2.8-series/discover/
