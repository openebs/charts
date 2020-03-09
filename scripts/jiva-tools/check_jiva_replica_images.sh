#!/bin/bash

# This need to be run as "bash check_jiva_replica_images.sh" in the directory where jiva replica img files are stored

# This script counts the chain length and compares it with the number of .img and .img.meta files
# If there is difference in the counts, it displays the same

# Please note that this script doesn't modify anything on the disk
# It reads *.img.meta files, and performs find command

set -euf -o pipefail

function getParent() {
	parent=`cat $1.meta | awk -F',' '{print $'$2'}'`
	key=`echo $parent | awk -F':' '{print $1}'`

	if [[ "$key" != "\"Parent\"" ]]; then
		echo "issue with volume.meta"
		exit 1
	fi

	val=`echo $parent | awk -F':' '{print $2}'`
	next=`echo $val | awk -F'"' '{print $2}'`
	echo $next
}

echo "volume.meta"
cat volume.meta
next=$(getParent volume 5)
chainLen=1

while [ "$next" != "" ]
do
	chainLen=`expr $chainLen + 1`
	grep $next du_out_$1
	grep $next ls_out_$1
	echo $next".meta"
	cat $next.meta
	next=$(getParent $next 2)
done

echo "ChainLen:"$chainLen

find . -iname '*.img'
imgCnt=`find . -iname '*.img' | wc -l`

echo "img files count:"$imgCnt

find . -iname '*.img.meta'
metaCnt=`find . -iname '*.img.meta' | wc -l`

echo "meta files count:"$metaCnt

if [ $chainLen -ne $imgCnt ]; then
	echo "chainLen and imgCnt doesn't match"
	exit 1
fi

if [ $chainLen -ne $metaCnt ]; then
	echo "ChainLen and metaCnt doesn't match"
	exit 1
fi

echo "No discrepancies found among the files in this replica"

