#!/bin/sh
version="$(podman run --rm -ti httpd httpd -V | head -n 1 | cut -d ' ' -f 3 | sed 's|.*/||')"
semvershort="$(echo "${version}" | sed 's/\([0-9]*\.[0-9]*\)\..*/\1/')"
if [ "${version}" == "${semvershort}" ]; then
    echo "${version}" > "${1}.tags"
else
    echo "${version} ${semvershort}" > "${1}.tags"
fi
echo "source: \"https://github.com/FST777/FreeBSD-OCI-images/httpd\"" > "${1}.yml"
pkg fetch -yo . apache24
pkg info -RF All/apache24*pkg >> "${1}.yml"
rm -rf All
