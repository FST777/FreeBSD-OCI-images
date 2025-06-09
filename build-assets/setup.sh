#!/bin/sh

# Set up PkgBase, to be used for container's root
mkdir -p /usr/local/etc/pkg/repos
cp build-assets/base.conf /usr/local/etc/pkg/repos/base.conf

# Install OCIJail container runtime + Red Hat's container tooling
# We primarily need buildah, but let's have the whole suite
pkg update
pkg upgrade -y
pkg install -y podman-suite

# Set up PF for networking
cp /usr/local/etc/containers/pf.conf.sample /etc/pf.conf
sed -i '' 's/ix0/vtnet0/' /etc/pf.conf
echo -e "net.ip.forwarding=1\nnet.pf.filter_local=1" >> /etc/sysctl.conf
service pf enable
service pf start
sysctl net.inet.ip.forwarding=1
sysctl net.pf.filter_local=1

# The runner is on UFS
sed -i '' -e 's/driver = "zfs"/driver = "vfs"/' /usr/local/etc/containers/storage.conf

# Set Podman's networking interfaces' MTU to 16834 (same as lo0)
# The default MTU leads to extremely slow networking due to fragmenting
mkdir -p /usr/local/etc/cni/net.d/
cp build-assets/podman-bridge.conflist /usr/local/etc/cni/net.d/
