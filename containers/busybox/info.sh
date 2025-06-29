#!/bin/sh
version="$(podman run --rm busybox busybox | grep -E '^BusyBox\ v' | sed 's/BusyBox\ v//;s/\ .*//')"
semvershort="$(echo "${version}" | sed 's/\([0-9]*\.[0-9]*\)\..*/\1/')"
if [ "${version}" == "${semvershort}" ]; then
    echo "${version}" > "${1}.tags"
else
    echo "${version} ${semvershort}" > "${1}.tags"
fi
echo "source: \"https://github.com/FST777/FreeBSD-OCI-images\"" > "${1}.yml"
pkg fetch -yo . busybox
pkg info -RF All/busybox*pkg >> "${1}.yml"
rm -rf All
