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
