# curiOS — a slim curated container OS

curiOS, pronounced curious, is a slim curated base for system containers.

curiOS is a wrapper around [Buildroot][0] for creating container images for
uploading to Docker Hub or similar.  Buildroot is an SDK for building embedded
Linux distributions.  It handles the removal of man pages, shared files, and
many pieces not germane to running on an embedded platform, and, as it turns
out, containers.

## Quick Start

 1. Clone this repo

        $ git clone https://github.com/kernelkit/curiOS
        $ cd curiOS/
        $ git submodule update --init

 2. Configure & Build

        $ make curious_amd64_defconfig
        $ make

 3. Upload your OCI image

        $ cd output/images
        $ ls rootfs-oci/
        blobs  index.json  oci-layout

        $ skopeo copy --dest-creds <user>:<pass> \
                oci:rootfs-oci:<tag> docker://<user>/<image>[:tag]

## Origin & References

curiOS is a fork of https://github.com/brianredbeard/coreos_buildroot

[0]: https://buildroot.org
