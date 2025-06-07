#!/bin/sh
version="$(podman run --rm busybox busybox | grep -E '^BusyBox\ v' | sed 's/BusyBox\ v//;s/\ .*//')"
semvershort="$(echo "${version}" | sed 's/\([0-9]*\.[0-9]*\)\..*/\1/')"
if [ "${version}" == "${semvershort}" ]; then
    echo "${version}"
else
    echo "${version} ${semvershort}"
fi
