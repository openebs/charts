#!/bin/sh

if [ -z "$1" ]; then
  echo Usage: $0 [REGISTRY]
  exit 1
fi

set -e -x
REGISTRY=$1

docker load --input openebs-images.tar.gz

docker tag quay.io/openebs/m-apiserver:1.9.0 ${REGISTRY}/quay.io/openebs/m-apiserver:1.9.0
docker push ${REGISTRY}/quay.io/openebs/m-apiserver:1.9.0
docker tag quay.io/openebs/jiva:1.9.0 ${REGISTRY}/quay.io/openebs/jiva:1.9.0
docker push ${REGISTRY}/quay.io/openebs/jiva:1.9.0
docker tag quay.io/openebs/cstor-istgt:1.9.0 ${REGISTRY}/quay.io/openebs/cstor-istgt:1.9.0
docker push ${REGISTRY}/quay.io/openebs/cstor-istgt:1.9.0
docker tag quay.io/openebs/cstor-pool:1.9.0 ${REGISTRY}/quay.io/openebs/cstor-pool:1.9.0
docker push ${REGISTRY}/quay.io/openebs/cstor-pool:1.9.0
docker tag quay.io/openebs/cstor-pool-mgmt:1.9.0 ${REGISTRY}/quay.io/openebs/cstor-pool-mgmt:1.9.0
docker push ${REGISTRY}/quay.io/openebs/cstor-pool-mgmt:1.9.0
docker tag quay.io/openebs/cstor-volume-mgmt:1.9.0 ${REGISTRY}/quay.io/openebs/cstor-volume-mgmt:1.9.0
docker push ${REGISTRY}/quay.io/openebs/cstor-volume-mgmt:1.9.0
docker tag quay.io/openebs/m-exporter:1.9.0 ${REGISTRY}/quay.io/openebs/m-exporter:1.9.0
docker push ${REGISTRY}/quay.io/openebs/m-exporter:1.9.0
docker tag quay.io/openebs/linux-utils:1.9.0 ${REGISTRY}/quay.io/openebs/linux-utils:1.9.0
docker push ${REGISTRY}/quay.io/openebs/linux-utils:1.9.0
docker tag quay.io/openebs/openebs-k8s-provisioner:1.9.0 ${REGISTRY}/quay.io/openebs/openebs-k8s-provisioner:1.9.0
docker push ${REGISTRY}/quay.io/openebs/openebs-k8s-provisioner:1.9.0
docker tag quay.io/openebs/snapshot-controller:1.9.0 ${REGISTRY}/quay.io/openebs/snapshot-controller:1.9.0
docker push ${REGISTRY}/quay.io/openebs/snapshot-controller:1.9.0
docker tag quay.io/openebs/snapshot-provisioner:1.9.0 ${REGISTRY}/quay.io/openebs/snapshot-provisioner:1.9.0
docker push ${REGISTRY}/quay.io/openebs/snapshot-provisioner:1.9.0
docker tag quay.io/openebs/node-disk-manager-amd64:v0.4.9 ${REGISTRY}/quay.io/openebs/node-disk-manager-amd64:v0.4.9
docker push ${REGISTRY}/quay.io/openebs/node-disk-manager-amd64:v0.4.9
docker tag quay.io/openebs/node-disk-operator-amd64:v0.4.9 ${REGISTRY}/quay.io/openebs/node-disk-operator-amd64:v0.4.9
docker push ${REGISTRY}/quay.io/openebs/node-disk-operator-amd64:v0.4.9
docker tag quay.io/openebs/admission-server:1.9.0 ${REGISTRY}/quay.io/openebs/admission-server:1.9.0
docker push ${REGISTRY}/quay.io/openebs/admission-server:1.9.0
docker tag quay.io/openebs/provisioner-localpv:1.9.0 ${REGISTRY}/quay.io/openebs/provisioner-localpv:1.9.0
docker push ${REGISTRY}/quay.io/openebs/provisioner-localpv:1.9.0
