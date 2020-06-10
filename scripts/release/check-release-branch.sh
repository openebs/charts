#!/bin/bash

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
  if [[ $REPO =~ ^# ]]; then
    echo "Skipping $REPO"
  else
    ./git-get-branch openebs/${REPO} ${REL_BRANCH}
  fi
done

#OpenEBS Release repositories with non-mainstream 
#branching convention
./git-get-branch openebs/linux-utils master
./git-get-branch openebs/zfs-localpv v0.8.x
./git-get-branch openebs/node-disk-manager v0.6.x
./git-get-branch openebs/monitor-pv master
./git-get-branch openebs/Mayastor master
./git-get-branch openebs/upgrade master
