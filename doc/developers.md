# Developer's Guide

## Idea

Small container images for embedded systems, built from source with
[Buildroot][0].  curiOS is a `BR2_EXTERNAL` tree, so everything you
know about Buildroot applies unchanged.


## Quick Start

 1. Clone this repo

        $ git clone https://github.com/kernelkit/curiOS
        $ cd curiOS/
        $ git submodule update --init --recursive

 2. Configure & build.  `make` with no configuration lists them all:

        $ make httpd_amd64_defconfig
        $ make

    Architectures are `amd64`, `arm64`, `armv7` and `riscv64`.  The
    `system` container is `amd64` and `arm64` only.

 3. Load the image

        $ podman load < output/images/curios-httpd-oci-x86_64.tar.gz

    Or push it straight to a registry:

        $ cd output/images
        $ skopeo copy --dest-creds <user>:<pass> \
                oci:rootfs-oci:<tag> docker://<user>/<image>[:tag]

 4. Test it

        $ make test


## A container for your own application

    $ make new-container NAME=mydaemon ARGS="--package --cmd /usr/sbin/mydaemon"

This writes defconfigs for every architecture, a board directory, and a
Buildroot package building from `src/mydaemon/`.  `utils/new-container
--help` lists the rest of the options.

To publish it, add the name to the matrix in
`.github/workflows/build.yml`.


## Repository layout

| Path        | Contents |
|-------------|----------|
| `configs/`  | one defconfig per container and architecture |
| `board/`    | per-container rootfs overlay, BusyBox configuration, health check |
| `package/`  | Buildroot packages not in upstream |
| `src/`      | source for the packages built locally |
| `utils/`    | SBOM, CVE, size and scaffolding tools |
| `test/`     | container tests, `test/case/` per image |
| `doc/infix/`| ready-made Infix configurations |


## SBOM and license compliance

    $ make sbom

Runs Buildroot's `legal-info` and converts its manifest into SPDX 2.3
and CycloneDX 1.6 in `output/images/sbom/`.  The complete corresponding
source lands in `output/legal-info/sources/` — the defconfigs link
statically, so shipping these images carries that obligation.

CVE status for the versions in a configuration:

    $ make httpd_amd64_defconfig
    $ make pkg-stats
    $ utils/cve-summary output/pkg-stats.json

The first run clones the NVD feed, which takes a while.


## Health checks

A container declares its check in
`board/<name>/rootfs/usr/libexec/curios/healthcheck.json`, and
`board/common/post-image.sh` writes it into the image configuration.

The probe, `/usr/libexec/curios/curios-health`, exists twice behind one
interface: an ash script in `board/common/rootfs/` for images with a
shell, and a static C implementation in `src/health/` for those without.
Only `curios-ntpd` needs the latter; it costs ~96 kB linked against
uClibc, almost all of it locale and printf tables that `__uClibc_main`
pulls in regardless.

> [!IMPORTANT]
> `src/` packages use Buildroot's `local` site method, which rsyncs the
> directory into the build tree.  Build artefacts left there from a host
> `make` get copied in and shadow the cross-compiled ones.  Run `make
> clean` in the source directory if a target binary comes out linked
> against the host libc.


## Contributing

We welcome and encourage outside contributions!  If you have any questions or
ideas to share, don't hesitate to get in touch.  We have a :speech_balloon:
[Forum][1] for discussions, or you can simply open an :bug: [Issue][2] or
Feature request.

[0]: https://buildroot.org
[1]: https://github.com/orgs/kernelkit/discussions
[2]: https://github.com/kernelkit/curiOS/issues
