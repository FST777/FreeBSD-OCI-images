#!/bin/sh
version="$(podman run --rm toybox toybox --version | cut -d ' ' -f 2)"
semvershort="$(echo "${version}" | sed 's/\([0-9]*\.[0-9]*\)\..*/\1/')"
if [ "${version}" == "${semvershort}" ]; then
    echo "${version}" > "${1}.tags"
else
    echo "${version} ${semvershort}" > "${1}.tags"
fi
echo "source: \"https://github.com/FST777/FreeBSD-OCI-images\"" > "${1}.yml"
pkg fetch -yo . toybox
pkg info -RF All/toybox*pkg >> "${1}.yml"
rm -rf All
