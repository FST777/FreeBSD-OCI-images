#!/bin/sh
version="$(podman run --rm runtime-pkg:latest freebsd-version -u | tr '[:upper:]' '[:lower:]')"
if echo "${version}" | grep -q "release"; then
    version="$(echo "${version}" | sed 's/-release//')"
    if echo "${version}" | grep -q "\-p"; then
        short="$(echo "${version}" | sed 's/-p[0-9]*//')"
        echo "${version} ${short}" > "${1}.tags"
    else
        echo "${version}-p0 ${version}" > "${1}.tags"
    fi
else
    echo "${version}" > "${1}.tags"
fi
cp containers/runtime-pkg/info.yml "${1}.yml"
