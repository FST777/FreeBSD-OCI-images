#!/bin/sh
echo " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo " >> Install jq/yq"
echo " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
sudo apt-get update
sudo apt-get install jq yq

echo " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo " >> Create manifest"
echo " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
buildah manifest create ${1}:latest oci-archive:${1}.x86-64.tar oci-archive:${1}.arm64.tar

echo " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo " > Give us a modern buildah"
echo " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
buildah from --name buildahbud alpine
buildah run buildahbud apk add buildah
buildah commit buildahbud buildah
podman run -d --name buildah --security-opt label=disable --security-opt seccomp=unconfined --device /dev/fuse:rw \
    -v ${HOME}/.local/share/containers:/var/lib/containers:Z buildah tail -f /dev/null

echo " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo " > Annotate manifest"
echo " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
if [ "$(yq '.comment + .licenses[0] + .source' ${1}.x86-64.yml)" != "$(yq '.comment + .licenses[0] + .source' ${1}.arm64.yml)" ]; then
    echo "The labels for the x86-64 and arm64 builds do not match!"
    exit 1
else
    podman exec buildah buildah manifest annotate --index \
        --annotation "org.opencontainers.image.licenses=$(yq -r ".licenses[0]" ${1}.x86-64.yml)" \
        --annotation "org.opencontainers.image.description=$(yq -r ".comment" ${1}.x86-64.yml)" \
        --annotation "org.opencontainers.image.source=$(yq -r ".source" ${1}.x86-64.yml)" \
        ${1}:latest
fi

echo " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo " >> Tag manifest"
echo " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
if ! diff -q ${1}.x86-64.tags ${1}.arm64.tags; then
    exit 1
else
    for tag in $(cat ${1}.x86-64.tags); do
        podman exec buildah buildah tag ${1}:latest "${1}:${tag}"
    done
fi

echo " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo " >> Output tags (cleaned up)"
echo " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "tags=latest $(cat ${1}.x86-64.tags)" > "${GITHUB_OUTPUT}"

echo " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo " >> Display result"
echo " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
buildah inspect "${1}:latest"
