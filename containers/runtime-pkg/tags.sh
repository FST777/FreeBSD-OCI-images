#!/bin/sh
version="$(podman run --rm runtime-pkg:latest freebsd-version -u | tr '[:upper:]' '[:lower:]')"
if echo "${version}" | grep -q "release"; then
    version="$(echo "${version}" | sed 's/-release//')"
    if echo "${version}" | grep -q "\-p"; then
        short="$(echo "${version}" | sed 's/-p[0-9]*//')"
        echo "${short} ${version}"
    else
    	echo "${version} ${version}-p0"
    fi
else
    echo "${version}"
fi
