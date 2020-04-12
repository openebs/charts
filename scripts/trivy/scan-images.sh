#!/bin/sh

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

IMGLIST=$(cat  openebs-images.txt |tr "\n" " ")

for IMG in $IMGLIST
do
  ./trivy -q --exit-code 1 --severity CRITICAL --no-progress $IMG:$RELEASE_TAG
done

#Images that do not follow the openebs release version
TIMGLIST=$(cat  openebs-fixed-tags.txt |tr "\n" " ")

for TIMG in $TIMGLIST
do
  ./trivy -q --exit-code 1 --severity CRITICAL --no-progress ${TIMG}
done
