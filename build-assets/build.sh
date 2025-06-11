#!/bin/sh

# Sort dependencies
echo -en "\e[34m"
echo " >> Sort dependencies"
echo -en "\e[0m"
LIST=""
for c in containers/*; do
    for d in $(grep FROM "${c}/Containerfile" | cut -d ' ' -f 2); do
        if [ -r "containers/${d}/Containerfile" ]; then
            LIST="${LIST}$(basename "${c}") ${d}\n"
        fi
    done
done

# Build images in order
echo -en "\e[34m"
echo " >> Build images"
echo -en "\e[0m"
for c in $(echo -e "${LIST}" | tsort | tail -r); do
    echo -en "\e[34m"
    echo " >>> ${c}"
    echo -en "\e[0m"

    # Some images need a non-containerized build
    mkdir -p "containers/${c}/root"
    if [ -x "containers/${c}/build.sh" ]; then
        echo -en "\e[34m"
        echo " >>>> run build.sh"
        echo -en "\e[0m"
        ./containers/${c}/build.sh
    fi

    # Build the image, package it as an archive
    echo -en "\e[34m"
    echo " >>>> buildah bud & push to archive"
    echo -en "\e[0m"
    buildah bud -t "${c}:latest" "./containers/${c}/Containerfile"
    buildah push "${c}:latest" "oci-archive:${c}.${1}.tar:${c}:latest"

    # Create image-specific tags
    echo -en "\e[34m"
    echo " >>>> construct tags and labels"
    echo -en "\e[0m"
    if [ -x "containers/${c}/info.sh" ]; then
        "./containers/${c}/info.sh" "${c}.${1}"
    else
        echo > "${c}.${1}.tags"
        echo > "${c}.${1}.yml"
    fi

    # Clean up (so the runner doesn't exit with an error)
    echo -en "\e[34m"
    echo " >>>> cleanup"
    echo -en "\e[0m"
    chflags -R noschg "containers/${c}/root" && rm -rf "containers/${c}/root"

    # If this is our core builder image, have a local version with pkg cache
    if [ "${c}" == "runtime-pkg" ]; then
        echo -en "\e[34m"
        echo " >>>> set up runtime-pkg as cached builder"
        echo -en "\e[0m"
        buildah from --name builder runtime-pkg
        buildah run builder pkg install -y FreeBSD-utilities
        buildah commit builder runtime-pkg
        buildah rm builder
    fi
done
