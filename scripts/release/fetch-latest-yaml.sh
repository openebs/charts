#!/bin/bash
# Copyright 2021 The OpenEBS Authors. All rights reserved.
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


usage()
{
	echo "Usage: $0 "
	exit 1
}

if [ $# -ne 0 ]; then
	usage
fi

fetch_engine_operator_yaml()
{
  REPO=${1}
  BRANCH=${2}
  DIR=${3}
  FILE=${4}
  TAG=${5}

  # Example: https://raw.githubusercontent.com/openebs/lvm-localpv/v0.8.x/deploy/lvm-operator.yaml
  #  REPO=lvm-localpv
  #  BRANCH=v0.8.x
  #  DIR=deploy
  #  FILE=lvm-operator.yaml
  C_URL="https://raw.githubusercontent.com/openebs/${REPO}/${BRANCH}/${DIR}/${FILE}"

  TEMP_RESP_FILE="temp-${FILE}"
  rm -rf ${TEMP_RESP_FILE}

  response_code=$(curl \
 -w "%{http_code}" \
 --silent \
 --output ${TEMP_RESP_FILE} \
 --url ${C_URL} \
 --request GET)

  rc_code=0

  if [ $response_code != "200" ]; then
    echo "Error: Not found ${C_URL}"
  else
    echo "Success: Downloaded ${C_URL} into ${TEMP_RESP_FILE}"
  fi

  sed -e 's@\:ci@'"\:$TAG"'@' -i ${TEMP_RESP_FILE}
  sed -e 's@\: ci@'"\: $TAG"'@' -i ${TEMP_RESP_FILE}
  sed -e 's@\: dev$@'"\: $TAG"'@' -i ${TEMP_RESP_FILE}
  sed -e 's@\:1.7.x-ci$@'"\:1.7.0"'@' -i ${TEMP_RESP_FILE}

  #rm -rf ${TEMP_RESP_FILE}

}

fetch_release_yamls()
{
  fetch_engine_operator_yaml "lvm-localpv" "v0.8.x" "deploy" "lvm-operator.yaml" "0.8.2"
  fetch_engine_operator_yaml "zfs-localpv" "v1.9.x" "deploy" "zfs-operator.yaml" "1.9.3"
  fetch_engine_operator_yaml "dynamic-nfs-provisioner" "v0.7.x" "deploy/kubectl" "openebs-nfs-provisioner.yaml" "0.7.1"
  fetch_engine_operator_yaml "device-localpv" "develop" "deploy" "device-operator.yaml" "0.5.1"
  fetch_engine_operator_yaml "dynamic-localpv-provisioner" "v3.0.x" "deploy/kubectl" "openebs-operator-lite.yaml" "3.0.0"
  fetch_engine_operator_yaml "dynamic-localpv-provisioner" "v3.0.x" "deploy/kubectl" "hostpath-operator.yaml" "3.0.0"
  fetch_engine_operator_yaml "dynamic-localpv-provisioner" "v3.0.x" "deploy/kubectl" "openebs-hostpath-sc.yaml" "3.0.0"
  fetch_engine_operator_yaml "jiva-operator" "develop" "deploy" "jiva-operator.yaml" "3.0.0"
  fetch_engine_operator_yaml "cstor-operators" "develop" "deploy" "cstor-operator.yaml" "3.0.0"
}

fetch_release_yamls
