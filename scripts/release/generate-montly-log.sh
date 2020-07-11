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

CHANGE_LOG="CHANGE_LOG_${REL_BRANCH}.md"
COMMITTER_LOG="COMMITTERS_${REL_BRANCH}.md"
rm -rf ${CHANGE_LOG}
rm -rf ${COMMITTER_LOG}

mkdir -p repos

setup_repo()
{
  REPODIR="repos/$1"

  if [[ -d $REPODIR ]]; then 
    cd $REPODIR && git pull && cd ../..
  else 
    REPOURL="https://github.com/openebs/$1"
    echo "Cloning $REPOURL into $REPODIR"
    cd repos && git clone $REPOURL && cd ..
  fi 

  cd $REPODIR && \
 git remote set-url --push origin no_push && \
 git remote -v && \
 cd ../..

}

change_log()
{
  setup_repo $1
  echo "==changelog for openebs/$1 ===" >> ${CHANGE_LOG}
  CHANGE_LOG_REPO="$1_${CHANGE_LOG}"
  rm -rf ${CHANGE_LOG_REPO}
  cd repos/$1
  git pull
  git checkout $2
  git log --pretty=format:'-TPL- %s (%h) (@%an)' --date=short  --since="1 month"  >> ../../${CHANGE_LOG_REPO}
  git log --pretty=format:'(@%an)' --date=short  --since="1 month"  >> ../../${COMMITTER_LOG}
  cd ../..
  sed -i "s/-TPL-/- [$1] /g" ${CHANGE_LOG_REPO}
  cat ${CHANGE_LOG_REPO} | sort  >> ${CHANGE_LOG}
  rm -rf ${CHANGE_LOG_REPO}
  echo $'\n' >> ${CHANGE_LOG}
}



REPO_LIST=$(cat openebs-repos.txt | grep -v "#" |tr "\n" " ")

for REPO in $REPO_LIST
do
  if [[ $REPO =~ ^# ]]; then
    echo "Skipping $REPO"
  else
    change_log ${REPO} ${REL_BRANCH}
  fi
done

#OpenEBS Release repositories with non-mainstream 
#branching convention
change_log linux-utils master
change_log node-disk-manager v0.7.x
change_log zfs-localpv v0.9.x
change_log e2e-tests master
change_log openebs-docs master
change_log openebs master
change_log monitor-pv master
change_log Mayastor master
change_log rawfile-localpv master
change_log charts master
change_log charts gh-pages
change_log website refactor-to-ghost-and-gatsby


committer_map()
{
  FILE=$1

  #Maintainers
  sed -i 's/@Kiran Mova/@kmova/g' ${FILE}
  sed -i 's/@Vishnu Itta/@vishnuitta/g' ${FILE}
  sed -i 's/@Jeffry Molanus/@gila/g' ${FILE}
  sed -i 's/@Karthik Satchitanand/@ksatchit/g' ${FILE}
  sed -i 's/@Murat Karslioglu/@muratkars/g' ${FILE}

  #Reviewers
  sed -i 's/@mayank/@mynktl/g' ${FILE}
  sed -i 's/@Mayank/@mynktl/g' ${FILE}
  sed -i 's/@sai chaithanya/@mittachaitu/g' ${FILE}
  sed -i 's/@Payes Anand/@payes/g' ${FILE}
  sed -i 's/@Utkarsh Mani Tripathi/@utkarshmani1997/g' ${FILE}
  sed -i 's/@shubham/@shubham14bajpai/g' ${FILE}
  sed -i 's/@Shubham Bajpai/@shubham14bajpai/g' ${FILE}
  sed -i 's/@Prateek Pandey/@prateekpandey14/g' ${FILE}
  sed -i 's/@Ashutosh Kumar/@sonasingh46/g' ${FILE}
  sed -i 's/@Pawan Prakash Sharma/@pawanpraka1/g' ${FILE}
  sed -i 's/@Pawan/@pawanpraka1/g' ${FILE}
  sed -i 's/@Akhil Mohan/@akhilerm/g' ${FILE}
  sed -i 's/@Aman Gupta/@w3aman/g' ${FILE}
  sed -i 's/@Filippo Bosi/@filippobosi/g' ${FILE}
  sed -i 's/@Amrish Kushwaha/@IsAmrish/g' ${FILE}
  sed -i 's/@giri/@gprasath/g' ${FILE}
  sed -i 's/@Ranjith R/@ranjithwingrider/g' ${FILE}
  sed -i 's/@Somesh Kumar/@somesh2905/g' ${FILE}
  sed -i 's/@sathyaseelan/@nsathyaseelan/g' ${FILE}
  sed -i 's/@Antonio Carlini/@AntonioCarlini/g' ${FILE}
  sed -i 's/@Blaise Dias/@blaisedias/g' ${FILE}
  sed -i 's/@Evan Powell/@epowell101/g' ${FILE}
  sed -i 's/@Glenn Bullingham/@GlennBullingham/g' ${FILE}
  sed -i 's/@Jan Kryl/@jkryl/g' ${FILE}
  sed -i 's/@Jonathan Teh/@jonathan-teh/g' ${FILE}
  sed -i 's/@yannis218/@yannis218/g' ${FILE}
  sed -i 's/@Shashank Ranjan/@shashank855/g' ${FILE}

  #Contributors -  Community Bridge
  sed -i 's/@Mehran Kholdi/@SeMeKh/g' ${FILE}
  sed -i 's/@Harsh Thakur/@harshthakur9030/g' ${FILE}
  sed -i 's/@vaniisgh/@vaniisgh/g' ${FILE}

  #Contributors -  Community
  sed -i 's/@Sumit Lalwani/@slalwani97/g' ${FILE}
  sed -i 's/@Peeyush Gupta/@Pensu/g' ${FILE}
  sed -i 's/@Christopher J. Ruwe/@cruwe/g' ${FILE}
  sed -i 's/@Sjors Gielen/@sgielen/g' ${FILE}
  sed -i 's/@Shubham Bhardwaj/@ShubhamB99/g' ${FILE}
  sed -i 's/@GTB3NW/@GTB3NW/g' ${FILE}
  sed -i 's/@fukuta-tatsuya-intec/@fukuta-tatsuya-intec/g' ${FILE}
  sed -i 's/@mtmn/@mtmn/g' ${FILE}
  sed -i 's/@Nick Pappas/@radicand/g' ${FILE}
  sed -i 's/@Nikolay Rusinko/@nrusinko/g' ${FILE}
  sed -i 's/@Zach Dunn/@zadunn/g' ${FILE}
  sed -i 's/@wiwen/@Icedroid/g' ${FILE}

  FILE=""
}

committer_map ${CHANGE_LOG}
committer_map ${COMMITTER_LOG}


sed -i 's/)(/)\n(/g' ${COMMITTER_LOG}
sort ${COMMITTER_LOG} | uniq
