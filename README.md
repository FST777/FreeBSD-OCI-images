# FreeBSD-OCI-images
Useful OCI container images for `--os=freebsd`

This project packages native FreeBSD software as OCI containers, combining
Jails with modern container tooling.

## What is this?
OCI containers on FreeBSD are a novel way to combine the time-tested power of
FreeBSD Jails with the simplicity and ubiquity of OCI-compatible tooling
(familiar from Linux platforms like Podman, Docker and Kubernetes).  They are
usable with containerd (via runj) as well as podman/buildah (via ocijail), all
of which are available via FreeBSD packages or ports.

Although FreeBSD's excellent Linux compatibility layer allows the use of
Linux-based containers, there is now an opportunity to package FreeBSD native
software as OCI containers. Currently, however, there is a dearth of images to
get people started — this repository seeks to fill that gap.

FreeBSD's pkg repository provides the included software. Images are built with
GitHub Actions and tagged with their minor and patch versions where applicable
(in addition to `latest`). Images are rebuilt every week as well as on
significant changes in the build code. For guaranteed consistency, use the
image SHA; for regular updates and improvements, follow the version tags that
best suit your needs.

## Available images

### runtime-pkg
- Get it from: [ghcr.io/fst777/runtime-pkg](https://github.com/FST777/cayman/pkgs/container/runtime-pkg)
- Pull using `ghcr.io/fst777/runtime-pkg:latest`

This image is now deprecated. For FreeBSD 14.2, this image was needed since the
upstream `freebsd-runtime`'s `pkg` did not cleanly self-install. Now that it
does, that image is preferable to our own solution. It is kept here for
posterity's sake.

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
FreeBSD userland on top of `freebsd-runtime`.

### busybox
- Get it from: [ghcr.io/fst777/busybox](https://github.com/FST777/cayman/pkgs/container/busybox)
- Pull using `ghcr.io/fst777/busybox:latest`

What it says on the tin. Usable as a minimal userland container, suitable for
hosting apps/scripts that require core shell utilities. Think of it as an
`alpine` image for FreeBSD.

### toybox
- Get it from: [ghcr.io/fst777/toybox](https://github.com/FST777/cayman/pkgs/container/toybox)
- Pull using `ghcr.io/fst777/toybox:latest`

What it says on the tin. Contains FreeBSD's own `/bin/sh` since toybox does not
include a shell. Usable as a minimal userland container, suitable for hosting
apps/scripts that require core shell utilities.

### Curated applications
- [memcached](containers/memcached/README.md)
- [nginx](containers/nginx/README.md)
- [redis](containers/redis/README.md)
- [fluent-bit](containers/fluent-bit/README.md)
- [kubectl](containers/kubectl/README.md)
