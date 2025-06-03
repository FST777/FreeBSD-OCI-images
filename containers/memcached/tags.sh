#!/bin/sh
podman run --rm memcached memcached -V | cut -d ' ' -f 2
