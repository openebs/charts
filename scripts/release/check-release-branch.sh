#!/bin/sh

usage()
{
	echo "Usage: $0 <release branch>"
	exit 1
}

if [ $# -ne 1 ]; then
	usage
fi

REL_BRANCH=$1

REPO_LIST=$(cat  openebs-repos.txt |tr "\n" " ")

for REPO in $REPO_LIST
do
  ./git-get-branch openebs/${REPO} ${REL_BRANCH}
done

#OpenEBS Release repositories with non-mainstream 
#branching convention
./git-get-branch openebs/linux-utils master
./git-get-branch openebs/zfs-localpv master
./git-get-branch openebs/node-disk-manager v0.4.x
