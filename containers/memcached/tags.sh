#!/bin/sh
version="$(podman run --rm memcached memcached -V | cut -d ' ' -f 2)"
semvershort="$(echo "${version}" | sed 's/\([0-9]*\.[0-9]*\)\..*/\1/')"
if [ "${version}" == "${semvershort}" ]; then
    echo "${version}"
else
    echo "${version} ${semvershort}"
fi
