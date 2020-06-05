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

CHANGE_LOG="CHANGE_LOG_${REL_BRANCH}.md"
COMMITTER_LOG="COMMITTERS_${REL_BRANCH}.md"
rm -rf ${CHANGE_LOG}
rm -rf ${COMMITTER_LOG}

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



REPO_LIST=$(cat  openebs-repos.txt |tr "\n" " ")

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
change_log node-disk-manager v0.5.x
change_log zfs-localpv v0.7.x
change_log e2e-tests master
change_log openebs-docs master
change_log openebs master
change_log monitor-pv master
change_log Mayastor master


committer_map()
{
  FILE=$1
  sed -i 's/@Kiran Mova/@kmova/g' ${FILE}
  sed -i 's/@mayank/@mynktl/g' ${FILE}
  sed -i 's/@Mayank/@mynktl/g' ${FILE}
  sed -i 's/@Vishnu Itta/@vishnuitta/g' ${FILE}
  sed -i 's/@sai chaithanya/@mittachaitu/g' ${FILE}
  sed -i 's/@Payes Anand/@payes/g' ${FILE}
  sed -i 's/@Utkarsh Mani Tripathi/@utkarshmani1997/g' ${FILE}
  sed -i 's/@shubham/@mynktl/g' ${FILE}
  sed -i 's/@Shubham Bajpai/@mynktl/g' ${FILE}
  sed -i 's/@Prateek Pandey/@prateekpandey14/g' ${FILE}
  sed -i 's/@Ashutosh Kumar/@sonasingh46/g' ${FILE}
  sed -i 's/@Pawan Prakash Sharma/@pawanpraka1/g' ${FILE}
  sed -i 's/@Pawan/@pawanpraka1/g' ${FILE}
  sed -i 's/@Akhil Mohan/@akhilerm/g' ${FILE}
  sed -i 's/@Aman Gupta/@w3aman/g' ${FILE}
  sed -i 's/@Sumit Lalwani/@slalwani97/g' ${FILE}
  sed -i 's/@Filippo Bosi/@filippobosi/g' ${FILE}
  sed -i 's/@Amrish Kushwaha/@IsAmrish/g' ${FILE}
  sed -i 's/@Jeffry Molanus/@gila/g' ${FILE}
  sed -i 's/@Karthik Satchitanand/@ksatchit/g' ${FILE}
  sed -i 's/@Murat Karslioglu/@muratkars/g' ${FILE}
  sed -i 's/@giri/@gprasath/g' ${FILE}
  sed -i 's/@Ranjith R/@ranjithwingrider/g' ${FILE}
  sed -i 's/@Somesh Kumar/@somesh2905/g' ${FILE}
  sed -i 's/@sathyaseelan/@nsathyaseelan/g' ${FILE}

  FILE=""
}

committer_map ${CHANGE_LOG}
committer_map ${COMMITTER_LOG}


sed -i 's/)(/)\n(/g' ${COMMITTER_LOG}
sort ${COMMITTER_LOG} | uniq
