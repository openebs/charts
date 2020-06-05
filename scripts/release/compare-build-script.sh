#!/bin/bash

usage()
{
	echo "Usage: $0 "
	exit 1
}

if [ $# -ne 0 ]; then
	usage
fi

compare_build_file()
{
  REPO=${1}
  BRANCH=${2}
  FILE=${3}
  DIR=${4}

  C_URL="https://raw.githubusercontent.com/openebs/${REPO}/${BRANCH}/${DIR}/${FILE}"

  TEMP_RESP_FILE=temp-curl-response.txt
  rm -rf ${TEMP_RESP_FILE}

  response_code=$(curl \
 -w "%{http_code}" \
 --silent \
 --output ${TEMP_RESP_FILE} \
 --url ${C_URL} \
 --request GET)

  rc_code=0

  if [ $response_code != "200" ]; then
    echo "Error: Not found ${C_URL}"
  else
    diff_lines=$(diff ./buildscripts/${FILE} $TEMP_RESP_FILE | wc -l)
    echo "Found $diff_lines for ${REPO}"
    if [ $diff_lines != 0 ]; then 
      diff ./buildscripts/${FILE} $TEMP_RESP_FILE 
    fi
  fi

  rm -rf ${TEMP_RESP_FILE}

}

check_git_release()
{
  compare_build_file linux-utils master git-release buildscripts
  compare_build_file libcstor master git-release buildscripts
  compare_build_file cstor develop git-release buildscripts
  compare_build_file istgt replication git-release buildscripts
  compare_build_file maya master git-release buildscripts
  compare_build_file external-storage release git-release openebs/buildscripts
  compare_build_file jiva-operator master git-release build
}

check_push()
{
  compare_build_file linux-utils master push buildscripts
  compare_build_file cstor develop push buildscripts
  compare_build_file istgt replication push buildscripts
  compare_build_file maya master push buildscripts
  compare_build_file external-storage release push openebs/buildscripts
  compare_build_file jiva-operator push push build
  compare_build_file node-disk-manager master push build
  compare_build_file jiva master push build
  compare_build_file jiva-csi master push build
  compare_build_file cstor-csi master push buildscripts
  compare_build_file cstor-operators master push buildscripts
  compare_build_file velero-plugin master push buildscripts
  compare_build_file zfs-localpv master push buildscripts
  compare_build_file monitor-pv master push buildscripts
}

check_git_release
check_push

