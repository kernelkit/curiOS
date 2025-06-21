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
    For instance, start with the system container:

        $ make curios_amd64_defconfig
        $ make

 3. Upload your OCI image

        $ cd output/images
        $ ls rootfs-oci/
        blobs  index.json  oci-layout

        $ skopeo copy --dest-creds <user>:<pass> \
                oci:rootfs-oci:<tag> docker://<user>/<image>[:tag]


## Contributing

We welcome and encourage outside contributions!  If you have any questions or
ideas to share, don't hesitate to get in touch.  We have a :speech_balloon:
[Forum][1] for discussions, or you can simply open an :bug: [Issue][2] or
Feature request.

[0]: https://buildroot.org
[1]: https://github.com/orgs/kernelkit/discussions
[2]: https://github.com/kernelkit/curiOS/issues
