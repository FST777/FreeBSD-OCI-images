#!/bin/sh
version="$(podman run --rm nginx nginx -V 2>&1 | head -n 1 | cut -d '/' -f 2)"
semvershort="$(echo "${version}" | sed 's/\([0-9]*\.[0-9]*\)\..*/\1/')"
if [ "${version}" == "${semvershort}" ]; then
    echo "${version}" > "${1}.tags"
else
    echo "${version} ${semvershort}" > "${1}.tags"
fi
echo "source: \"https://github.com/FST777/FreeBSD-OCI-images/nginx\"" > "${1}.yml"
pkg fetch -yo . nginx
pkg info -RF All/nginx*pkg >> "${1}.yml"
rm -rf All
