#!/bin/sh
podman run --rm busybox busybox | grep -E '^BusyBox\ v' | sed 's/BusyBox\ v//;s/\ .*//'
