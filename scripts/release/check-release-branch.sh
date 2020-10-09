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
	echo "Usage: $0 <release branch>"
	exit 1
}

if [ $# -ne 1 ]; then
	usage
fi

REL_BRANCH=$1

REPO_LIST=$(cat  openebs-repos.txt | grep -v "#" |tr "\n" " ")

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
./git-get-branch openebs/zfs-localpv v1.0.x
./git-get-branch openebs/node-disk-manager v0.9.x
./git-get-branch openebs/monitor-pv master
./git-get-branch openebs/Mayastor master
./git-get-branch openebs/rawfile-localpv master
./git-get-branch openebs/jiva-operator master
./git-get-branch openebs/jiva-csi master
