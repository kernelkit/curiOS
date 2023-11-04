# curiOS a minimal container OS

curiOS, pronounced curious, is a base for building tiny container systems.

curiOS, at its core, is just a wrapper around [Buildroot][0] that can take
your defconfig and create a container image for uploading to Docker Hub or
similar.  Buildroot is an SDK for building embedded Linux distributions.  It
handles the removal of man pages, shared files, and many pieces not germane
to running on an embedded platform.

# Origin & References

curiOS is a fork of https://github.com/brianredbeard/coreos_buildroot

[0]: https://buildroot.org
