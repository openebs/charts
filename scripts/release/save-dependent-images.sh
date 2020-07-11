#!/bin/sh
# Copyright 2020 The OpenEBS Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# OpenEBS depends on some of the community generated images
# like CSI images. This script will help the version of 
# those images under openebs quay and docker orgs. 

save_image()
{
  REG=$1
  ORG=$2
  IMG=$3
  TAG=$4
  docker pull ${REG}${ORG}/${IMG}:${TAG}
  docker tag  ${REG}${ORG}/${IMG}:${TAG} openebs/${ORG}_${IMG}:${TAG}
  docker tag  ${REG}${ORG}/${IMG}:${TAG} quay.io/openebs/${ORG}_${IMG}:${TAG}
  docker push quay.io/openebs/${ORG}_${IMG}:${TAG}
  docker push openebs/${ORG}_${IMG}:${TAG}
}

#The list of previously saved images are commented out.
#To save a new image, add a new entry at the bottom, run the script
# and after verifying the images is save in openebs org, comment the line.
#save_image "quay.io/" "k8scsi" "csi-resizer" "v0.4.0"
#save_image "quay.io/" "k8scsi" "csi-node-driver-registrar" "v1.2.0"
#save_image "quay.io/" "k8scsi" "csi-provisioner" "v1.6.0"
#save_image "quay.io/" "k8scsi" "csi-snapshotter" "v2.0.1"
#save_image "quay.io/" "k8scsi" "snapshot-controller" "v2.0.1"
