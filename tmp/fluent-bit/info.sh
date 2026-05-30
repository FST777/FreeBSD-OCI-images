#!/bin/sh
version="$(podman run --rm fluent-bit fluent-bit -V | head -n 1 | cut -d ' ' -f 3 | sed 's/v//')"
semvershort="$(echo "${version}" | sed 's/\([0-9]*\.[0-9]*\)\..*/\1/')"
if [ "${version}" == "${semvershort}" ]; then
    echo "${version}" > "${1}.tags"
else
    echo "${version} ${semvershort}" > "${1}.tags"
fi
echo "source: \"https://github.com/FST777/FreeBSD-OCI-images/fluent-bit\"" > "${1}.yml"
pkg fetch -yo . fluent-bit
pkg info -RF All/fluent-bit*pkg >> "${1}.yml"
rm -rf All
