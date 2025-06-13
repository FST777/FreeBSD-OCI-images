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
podman exec buildah buildah manifest annotate --index \
    --annotation "org.opencontainers.image.licenses=$(yq -r ".licenses[0]" ${1}.x86-64.yml)" \
    --annotation "org.opencontainers.image.description=$(yq -r ".comment" ${1}.x86-64.yml)" \
    --annotation "org.opencontainers.image.source=$(yq -r ".source" ${1}.x86-64.yml)" \
    ${1}:latest

echo " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo " >> Tag manifest"
echo " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
for tag in $(cat ${1}.x86-64.tags) $(cat ${1}.arm64.tags); do
    podman exec buildah buildah tag ${1}:latest "${1}:${tag}"
done

echo " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo " >> Output tags (cleaned up)"
echo " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "tags=latest $(for tag in $(cat ${1}.x86-64.tags) $(cat ${1}.arm64.tags); do echo "${tag}"; done | sort | uniq | paste -sd ' ')" > "${GITHUB_OUTPUT}"

echo " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo " >> Display result"
echo " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
buildah inspect "${1}:latest"
