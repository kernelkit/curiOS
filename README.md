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
$ git clone git@github.com:brianredbeard/coreos_buildroot.git
```

Step 3 - Reference the `coreos_buildroot` directory from `buildroot`:

```
$ cd buildroot
$ make BR2_EXTERNAL=../coreos_buildroot menuconfig
```
This connects the two repos together and exposes all of the coreos_buildroot
options through the menu option `"User-provided options  --->"`

## Using CoreOS Buildroot

### Creating a new `defconfig`

defconfigs are default sets of options which are used to populate a `.config`
file inside of buildroot.  Using a defconfig file one is able to persist a list
of configuration options beyond the life cycle of a single checkout of
buildroot.  This is to say that the defconfig removes things not essential to
the generation of the user defined filesystem so that as various default options
change over time, the user is able to cleanly integrate them.

To create a new defconfig file the user will configure the container and then
perform a save operation which will strip out the extraneous configuration
options.  The starting process for this can begin in two ways: Start from an 
empty config (e.g. `make menuconfig` from within a clean repository checkout) or
start from another defconfig, mutate it, and save the changes.  In the first
case it is just as simple as removing an existing `.config` file from the
upstream buildroot checkout and running `make menuconfig`.

If one wishes to start from an existing defconfig, they will identify the
configuration they wish to start from in either
[buildroot/configs](https://github.com/buildroot/buildroot/tree/master/configs)
or from
[coreos_buildroot/configs](https://github.com/brianredbeard/coreos_buildroot/tree/master/configs).

Once a starting defconfig has been chosen, one uses the name of that defconfig
as as argument to `make`, e.g. `make corebox_defconfig` and then makes relevant
changes using `make menuconfig`.

After any desired changes have been made through `make menuconfig`, the command
`make savedefconfig` is used.  If one wishes to provide a filename for the saved
artifact, it can be supplied with the variable `BR2_DEFCONFIG`, e.g. `make
savedefconfig BR2_DEFCONFIG=../coreos_buildroot/configs/example_defconfig`.  Any
defconfigs should always end with the string `_defconfig`.

### Things to remember when defining options for a generated artifact

In the process of building a container filesystem there are a number of things
that you will not need as compared to a full Linux distro.  Some examples are an
init system (e.g. sysVinit or systemd) or a kernel.  At the same time many users
will realize that they do not need
[locales](http://www.gnu.org/software/libc/manual/html_node/Locales.html) beyond
"`C`" or "`POSIX`".

What some users may not understand is that even when *not* building a kernel,
the _kernel headers_ will still be needed to establish an [application binary
interface](https://en.wikipedia.org/wiki/Linux_kernel_interfaces#Linux_ABI)
contract for program execution.  As a part of this contract one must always use
a _lower_ version of the kernel headers than the kernel on the desired system.
This means that 3.4.3 kernel headers can be used with a 3.10.0 or a 4.4.5
kernel, but not a 2.6.32 kernel.  This becomes important because a user needs to
decide what is an appropriate level of kernel headers to use for a desired
platform.  This means that should a user choose to use the "latest and greatest"
version of the kernel headers it _may_ work on a CoreOS alpha instance but would
not run on a CoreOS stable nor a Red Hat Enterprise Linux host.  In general,
sticking to using 3.4.x kernel headers is a safe bet which provides a broad
level of compatibility across kernel versions.
