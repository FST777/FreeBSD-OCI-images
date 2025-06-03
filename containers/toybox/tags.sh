#!/bin/sh
podman run --rm toybox toybox --version | cut -d ' ' -f 2
