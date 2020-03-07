#!/bin/sh

usage()
{
	echo "Usage: $0 <openebs version>"
	exit 1
}

if [ $# -ne 1 ]; then
	usage
fi

RELEASE_TAG=$1

IMGLIST=$(cat  openebs-images.txt |tr "\n" " ")

for IMG in $IMGLIST
do
  sudo trivy --exit-code 1 --severity CRITICAL --no-progress $IMG:$RELEASE_TAG
done

#Images that do not follow the openebs release version
TIMGLIST=$(cat  openebs-fixed-tags.txt |tr "\n" " ")

for TIMG in $TIMGLIST
do
  sudo trivy --exit-code 1 --severity CRITICAL --no-progress ${TIMG}
done
