# FreeBSD-OCI-images
Useful OCI container images for `---os=freebsd`

## What is this?
OCI containers on FreeBSD are a new and novel way to use the decades old robust
Jails mechanism with the ease of use of OCI compatible packaging, handling and
distribution that is commonplace on Linux with Podman, Docker and friends. It
is useable with containerd (via runj) as well as podman/buildah (via ocijail),
all available via FreeBSD packages or ports.

While FreeBSD's excellent Linux compatibility layer allows for decent usage of
Linux-based containers, there is an opportunity to package FreeBSD native
software this way as well. However, at the time of writing there is a dearth of
base images to allow for this. This repository seeks to fill that gap.

At the moment, building images is done via GitHub Actions. It has not yet been
set up to use intelligent tagging, so all images result in only having the
`latest` tag set. Use their SHA if you need stability, stable version-based
tagging will come later.

The available images are:

### runtime-pkg
- Get it from: [ghcr.io/fst777/runtime-pkg](https://github.com/FST777/cayman/pkgs/container/runtime-pkg)
- Pull using `ghcr.io/fst777/runtime-pkg:latest`

A minimal FreeBSD userspace runtime with a working and initialized `pkg`.
Inspired by [the `freebsd-runtime` image as found on Docker
Hub](https://hub.docker.com/r/freebsd/freebsd-runtime). It comes with
repository definitions for the default pkg repo as well as PkgBase. This image
is most suitable for building more targeted images in a multi-stage build
configuration. Be aware that all use of the pkg command inside this image will
greatly inflate its size due to pkg's caching mechanism.

### userland
- Get it from: [ghcr.io/fst777/userland](https://github.com/FST777/cayman/pkgs/container/userland)
- Pull using `ghcr.io/fst777/userland:latest`

A curated set of additional packages intended to provide a fairly complete
FreeBSD userland on top of `runtime-pkg`.

### busybox
- Get it from: [ghcr.io/fst777/busybox](https://github.com/FST777/cayman/pkgs/container/busybox)
- Pull using `ghcr.io/fst777/busybox:latest`

What it says on the tin. Usable as a minimal userland container, suitable for
hosting apps/scripts that require core shell utilities.

### toybox
- Get it from: [ghcr.io/fst777/toybox](https://github.com/FST777/cayman/pkgs/container/toybox)
- Pull using `ghcr.io/fst777/toybox:latest`

What it says on the tin, combined with FreeBSD's own `/bin/sh` since toybox
does not include this. Usable as a minimal userland container, suitable for
hosting apps/scripts that require core shell utilities.
