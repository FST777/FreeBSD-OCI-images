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
echo " >> Annotate manifest (license, source, description)"
echo " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
for digest in $(buildah inspect ${1}:latest | jq -r '.manifests[].digest'); do
    buildah manifest annotate \
        --annotation "org.opencontainers.image.licenses=$(yq -r ".licenses[0]" ${1}.x86-64.yml)" \
        --annotation "org.opencontainers.image.description=$(yq -r ".comment" ${1}.x86-64.yml)" \
        --annotation "org.opencontainers.image.source=$(yq -r ".source" ${1}.x86-64.yml)" \
        ${1}:latest "${digest}"
done

echo " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo " >> Tag manifest"
echo " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
for tag in $(cat ${1}.x86-64.tags) $(cat ${1}.arm64.tags); do
    buildah tag ${1}:latest "${1}:${tag}"
done

echo " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo " >> Output tags (cleaned up)"
echo " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "tags=latest $(for tag in $(cat ${1}.x86-64.tags) $(cat ${1}.arm64.tags); do echo "${tag}"; done | sort | uniq | paste -sd ' ')" > "${GITHUB_OUTPUT}"

echo " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo " >> Display result"
echo " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
buildah inspect "${1}:latest"
