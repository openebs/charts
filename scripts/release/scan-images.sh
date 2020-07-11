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


# Scan for critical security vulnerabilities in openebs
# container images using trivy. 

usage()
{
	echo "Usage: $0 <openebs version>"
	exit 1
}

if [ $# -ne 1 ]; then
	usage
fi

RELEASE_TAG=$1

download_trivy() {
	VERSION=$(curl --silent \
 "https://api.github.com/repos/aquasecurity/trivy/releases/latest" | \
 grep '"tag_name":' | \
 sed -E 's/.*"v([^"]+)".*/\1/' \
 )

	wget -q https://github.com/aquasecurity/trivy/releases/download/v${VERSION}/trivy_${VERSION}_Linux-64bit.tar.gz

	tar zxvf trivy_${VERSION}_Linux-64bit.tar.gz trivy

	rm trivy_${VERSION}_Linux-64bit.tar.gz*
}

if [ ! -f ./trivy ]; then
	download_trivy
fi


FAILED_IMGS=""
SCANNED_IMGS=""

trivy_scan()
{
  IMG=$1
  if [[ $IMG =~ ^# ]]; then
    echo "Skipping $IMG"
  else
    ./trivy -q --exit-code 1 --severity CRITICAL --no-progress $IMG
    if [ $? -ne 0 ]; then
      echo "Failed scanning $IMG"
      FAILED_IMGS="${1}\n${FAILED_IMGS}"
    else
      echo "Successfully scanned $IMG"
      SCANNED_IMGS="${1}\n${SCANNED_IMGS}"
    fi
  fi
}

quay_trivy_scan()
{
  IMG=$1
  if [[ $IMG =~ ^# ]]; then
    echo "Skipping quay scan for $IMG"
  else
    trivy_scan quay.io/${IMG}
  fi
}

OIMGLIST=$(cat  openebs-images.txt | grep -v "#" |tr "\n" " ")
for OIMG in $OIMGLIST
do
  trivy_scan $OIMG:$RELEASE_TAG
  quay_trivy_scan $OIMG:$RELEASE_TAG
done

#Images that do not follow the openebs release version
FIMGLIST=$(cat  openebs-fixed-tags.txt | grep -v "#" |tr "\n" " ")
for FIMG in $FIMGLIST
do
  trivy_scan ${FIMG}
  quay_trivy_scan ${FIMG}
done

#ARM Images
AIMGLIST=$(cat  openebs-arm-tags.txt | grep -v "#" |tr "\n" " ")
for AIMG in $AIMGLIST
do
  trivy_scan ${AIMG}
  quay_trivy_scan ${AIMG}
done

#Multi arch images that are only available from docker
MIMGLIST=$(cat  openebs-multiarch-tags.txt | grep -v "#" |tr "\n" " ")
for MIMG in $MIMGLIST
do
  trivy_scan ${MIMG}
done

echo 
if [ ! -z ${FAILED_IMGS} ]; then 
  echo "Error: Failures detected on the following images:"
  printf ${FAILED_IMGS}
  echo
else
  echo "Success: Successfully scanned all the following images:"
  printf ${SCANNED_IMGS}
fi 
