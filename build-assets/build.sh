#!/bin/sh

# Sort dependencies
LIST=""
for c in containers/*; do
    for d in $(grep FROM "${c}/Containerfile" | cut -d ' ' -f 2); do
        if [ -r "containers/${d}/Containerfile" ]; then
            LIST="${LIST}$(basename "${c}") ${d}\n"
        fi
    done
done

# Build images in order
for c in $(echo -e "${LIST}" | tsort | tail -r); do
    # Some images need a non-containerized build
    mkdir -p "containers/${c}/root"
    if [ -x "containers/${c}/build.sh" ]; then
        ./containers/${c}/build.sh
    fi

    # Build the image, package it as an archive
    buildah bud -t "${c}:latest" "./containers/${c}/Containerfile"
    buildah push "${c}:latest" "oci-archive:${c}.${{ matrix.architecture }}.tar:${c}:latest"

    # Create image-specific tags
    if [ -x "containers/${c}/tags.sh" ]; then
        ./containers/${c}/tags.sh > "${c}.${{ matrix.architecture }}.tags"
    else
        echo > "${c}.${{ matrix.architecture }}.tags"
    fi

    # Clean up (so the runner doesn't exit with an error)
    chflags -R noschg "containers/${c}/root" && rm -rf "containers/${c}/root"
done
