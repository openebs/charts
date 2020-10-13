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

usage()
{
	echo "Usage: $0 <release tag>"
	exit 1
}

if [ $# -ne 1 ]; then
	usage
fi

# remove the v prefix from the release tag if it exists
RELEASE_TAG=${1#v}

IMAGE_LIST=$(cat openebs-images.txt | grep -v "#" |tr "\n" " ")

for IMAGE in $IMAGE_LIST
do
  ./check-docker-img-tag.sh $IMAGE $RELEASE_TAG
done

# check images having fixed tags in docker hub
FIXED_TAGS_LIST=$(cat openebs-fixed-tags.txt | grep -v "#" |tr "\n" " ")

for IMAGE_TAG in $FIXED_TAGS_LIST
do
  IMAGE=$(echo $IMAGE_TAG | cut -d':' -f 1)
  TAG=$(echo $IMAGE_TAG | cut -d':' -f 2)
  ./check-docker-img-tag.sh $IMAGE $TAG
done