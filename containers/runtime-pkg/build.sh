#!/bin/sh
rootdir="containers/runtime-pkg/root/"
mkdir -p "${rootdir}usr/share/keys/pkg"
mkdir -p "${rootdir}etc/pkg"
mkdir -p "${rootdir}usr/local/etc/pkg/repos"
cp -r /usr/share/keys/pkg/trusted "${rootdir}usr/share/keys/pkg/"
cp /etc/pkg/*.conf "${rootdir}etc/pkg/"
cp /usr/local/etc/pkg/repos/*.conf "${rootdir}usr/local/etc/pkg/repos/"
pkg -r "${rootdir}" install -y pkg FreeBSD-runtime FreeBSD-caroot FreeBSD-certctl FreeBSD-rc
rm -rf "${rootdir}var/db/pkg/repos" "${rootdir}var/cache/pkg" "${rootdir}usr/local/sbin/pkg-static"
chroot "${rootdir}" /etc/rc.d/ldconfig start
