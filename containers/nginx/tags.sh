#!/bin/sh
version="$(podman run --rm nginx nginx -V 2>&1 | head -n 1 | cut -d '/' -f 2)"
semvershort="$(echo "${version}" | sed 's/\([0-9]*\.[0-9]*\)\..*/\1/')"
if [ "${version}" == "${semvershort}" ]; then
    echo "${version}"
else
    echo "${version} ${semvershort}"
fi
