#!/bin/sh
version="$(podman run --rm toybox toybox --version | cut -d ' ' -f 2)"
semvershort="$(echo "${version}" | sed 's/\([0-9]*\.[0-9]*\)\..*/\1/')"
if [ "${version}" == "${semvershort}" ]; then
    echo "${version}"
else
    echo "${version} ${semvershort}"
fi
