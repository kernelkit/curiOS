# Developer's Guide

## Idea

The founding idea behind this project is to provide small container
images for embedded systems using [Buildroot][0].

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


[0]: https://buildroot.org
