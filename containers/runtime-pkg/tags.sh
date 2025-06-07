#!/bin/sh
version="$(podman run --rm runtime-pkg:latest freebsd-version -u | tr '[:upper:]' '[:lower:]')"
if echo "${version}" | grep -q "release"; then
    version="$(echo "${version}" | sed 's/-release//')"
    if echo "${version}" | grep -q "\-p"; then
        short="$(echo "${version}" | sed 's/-p[0-9]*//')"
        echo "${version} ${short}"
    else
        echo "${version}-p0 ${version}"
    fi
else
    echo "${version}"
fi
