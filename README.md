# CoreOS Buildroot Addons

## About

Buildroot is an SDK for building embedded Linux distributions.  It handles the
removal of man pages, shared files, and many pieces not germaine to running
on an embedded platform.  At CoreOS we use Buildroot for the generation of 
[minimal containers](https://github.com/brianredbeard/minimal_containers) for
use with [rkt](https://github.com/coreos/rkt) and Docker.

## Quick Start

To get started using these pieces one should do the following:

Step 1 - Clone [buildroot](https://github.com/buildroot/buildroot):

```
$ git clone git@github.com:buildroot/buildroot.git
```

Step 2 - Clone CoreOS_buildroot (note: this should not be in the buildroot
directory):

```
$ git clone git@github.com:brianredbeard/buildroot.git
```

Step 3 - Reference the `coreos_buildroot` directory from `buildroot`:

```
$ cd buildroot
$ make BR2_EXTERNAL=../coreos_buildroot menuconfig
```
This connects the two repos together and exposes all of the coreos_buildroot
options through the menu option "User-provided options  --->"

