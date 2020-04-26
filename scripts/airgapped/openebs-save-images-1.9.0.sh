#!/bin/sh
set -e -x

docker pull quay.io/openebs/m-apiserver:1.9.0
docker pull quay.io/openebs/jiva:1.9.0
docker pull quay.io/openebs/cstor-istgt:1.9.0
docker pull quay.io/openebs/cstor-pool:1.9.0
docker pull quay.io/openebs/cstor-pool-mgmt:1.9.0
docker pull quay.io/openebs/cstor-volume-mgmt:1.9.0
docker pull quay.io/openebs/m-exporter:1.9.0
docker pull quay.io/openebs/linux-utils:1.9.0
docker pull quay.io/openebs/openebs-k8s-provisioner:1.9.0
docker pull quay.io/openebs/snapshot-controller:1.9.0
docker pull quay.io/openebs/snapshot-provisioner:1.9.0
docker pull quay.io/openebs/node-disk-manager-amd64:v0.4.9
docker pull quay.io/openebs/node-disk-operator-amd64:v0.4.9
docker pull quay.io/openebs/admission-server:1.9.0
docker pull quay.io/openebs/provisioner-localpv:1.9.0

docker save quay.io/openebs/m-apiserver:1.9.0 quay.io/openebs/jiva:1.9.0 quay.io/openebs/cstor-istgt:1.9.0 quay.io/openebs/cstor-pool:1.9.0 quay.io/openebs/cstor-pool-mgmt:1.9.0 quay.io/openebs/cstor-volume-mgmt:1.9.0 quay.io/openebs/m-exporter:1.9.0 quay.io/openebs/linux-utils:1.9.0 quay.io/openebs/openebs-k8s-provisioner:1.9.0 quay.io/openebs/snapshot-controller:1.9.0 quay.io/openebs/snapshot-provisioner:1.9.0 quay.io/openebs/node-disk-manager-amd64:v0.4.9 quay.io/openebs/node-disk-operator-amd64:v0.4.9 quay.io/openebs/admission-server:1.9.0 quay.io/openebs/provisioner-localpv:1.9.0 | gzip -c > openebs-images.tar.gz
