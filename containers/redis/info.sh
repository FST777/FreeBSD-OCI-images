#!/bin/sh
version="$(podman run --rm redis redis-server --version | cut -d ' ' -f 3 | cut -d '=' -f 2)"
semvershort="$(echo "${version}" | sed 's/\([0-9]*\.[0-9]*\)\..*/\1/')"
if [ "${version}" == "${semvershort}" ]; then
    echo "${version}" > "${1}.tags"
else
    echo "${version} ${semvershort}" > "${1}.tags"
fi
echo "source: \"https://github.com/FST777/FreeBSD-OCI-images/redis\"" > "${1}.yml"
pkg fetch -yo . redis
pkg info -RF All/redis*pkg >> "${1}.yml"
rm -rf All
