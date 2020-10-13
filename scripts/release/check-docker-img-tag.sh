#!/bin/bash
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

if [ "$#" -ne 2 ]; then
  echo "Error: Unable to get details of image from docker. Missing required input."
  echo "Usage: $0 <docker-registry-org/image> <image-tag>"
  echo "Example: $0 openebs/maya 2.2.0"
  exit 1
fi

IMAGE=$1
TAG=$2

function docker_tag_exists() {
  curl --silent -f --head -lL https://hub.docker.com/v2/repositories/$1/tags/$2/ > /dev/null
}

# Check the imaage tag in docker hub and prints the message with unicode check mark
# and cross for success and failure messages
if docker_tag_exists $IMAGE $TAG; then
  echo -e "\xE2\x9C\x94 $IMAGE:$TAG exists in docker hub"
  exit 0
else
  echo -e "\xE2\x9D\x8C $IMAGE:$TAG does not exist in docker hub"
  exit 1
fi
