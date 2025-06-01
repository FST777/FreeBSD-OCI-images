#!/bin/sh
podman run --rm toybox toybox --version | sed 's/.*\ //'
