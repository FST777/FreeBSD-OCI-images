#!/bin/sh
version="$(podman run --rm memcached memcached -V | cut -d ' ' -f 2)"
semvershort="$(echo "${version}" | sed 's/\([0-9]*\.[0-9]*\)\..*/\1/')"
if [ "${version}" == "${semvershort}" ]; then
    echo "${version}" > "${1}.tags"
else
    echo "${version} ${semvershort}" > "${1}.tags"
fi
pkg fetch -yo . memcached
pkg info -RF All/memcached*pkg > "${1}.yml"
rm -rf All
echo "source: \"https://github.com/FST777/FreeBSD-OCI-images/memcached\"" >> "${1}.yml"
