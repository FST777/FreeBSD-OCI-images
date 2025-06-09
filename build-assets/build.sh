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
    buildah push "${c}:latest" "oci-archive:${c}.${1}.tar:${c}:latest"

    # Create image-specific tags
    if [ -x "containers/${c}/info.sh" ]; then
        "./containers/${c}/info.sh" "${c}.${1}"
    else
        echo > "${c}.${1}.tags"
        echo > "${c}.${1}.yml"
    fi

    # Clean up (so the runner doesn't exit with an error)
    chflags -R noschg "containers/${c}/root" && rm -rf "containers/${c}/root"

    # If this is our core builder image, have a local version with pkg cache
    if [ "${c}" == "runtime-pkg" ]; then
        buildah from --name builder runtime-pkg
        buildah run builder pkg install -y FreeBSD-utilities
        buildah commit builder runtime-pkg
        buildah rm builder
    fi
done
