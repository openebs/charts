#!/bin/bash

# This need to be run as "bash jiva_preupgrade_checks.sh" in the directory where jiva replica img files are stored

# This script counts the chain length and compares it with the number of .img and .img.meta files
# If there is difference in the counts, it displays the same

# It reads *.img.meta files, and performs find command

# Please note that this script doesn't modify anything on the disk, but, 
# dumps filefrag of img files output into *.frag and *.fragout files

set -euf -o pipefail

function getAttr() {
	parent=$(awk -F',' '{print $'"$3"'}' "$1".meta)
	key=$(echo "$parent" | awk -F':' '{print $1}')

	if [[ "$key" != \"$2\" ]]; then
		echo "issue with $1.meta" >&2
		exit 1
	fi

	val=$(echo "$parent" | awk -F':' '{print $2}')
	next=$(echo "$val" | awk -F'"' '{print $2}')
	echo "$next"
}

function createFragOut() {
	filefrag -e "$1" > "$2".frag
	lines=$(grep -vc File "$2".frag)
	if [ "$lines" -ne 1 ]; then
		grep -v File "$2".frag | grep -v ext | awk -F':' '{print $2}' | awk -F'.' '{print $1" "$3}' > "$2".fragout
	else
		echo -n > "$2".fragout
	fi
}

echo "volume.meta" > jiva_preupgrade_check.out
cat volume.meta >> jiva_preupgrade_check.out
next=$(getAttr volume "Parent" 5)
head=$(getAttr volume "Head" 2)
echo "$head" >> jiva_preupgrade_check.out
du -s "$head" >> jiva_preupgrade_check.out
size=$(du -s "$head" | awk '{print $1}')
chainLen=1
createFragOut "$head" $chainLen

while [ "$next" != "" ]
do
	chainLen=$((chainLen + 1))
	createFragOut "$next" $chainLen
	{
		echo "$next.meta"
		du -s "$next"
		cat "$next.meta"
	} >> jiva_preupgrade_check.out
	img_size=$(du -s "$next" | awk '{print $1}')
	size=$((size + img_size))
	next=$(getAttr "$next" "Parent" 2)
done

echo "Total used size: $size"

echo "Chain Length: $chainLen"

imgCnt=$(find . -iname '*.img' | wc -l)
echo "img files count: $imgCnt"

metaCnt=$(find . -iname '*.img.meta' | wc -l)
echo "meta files count:$metaCnt"

{
	echo "Total used size: $size"
	echo "Chain Length: $chainLen"

	ls -ltr
	find . -exec du -s {} \;

	echo "img files count: $imgCnt"
	echo "meta files count:$metaCnt"
} >> jiva_preupgrade_check.out

if [ $chainLen -ne "$imgCnt" ]; then
	echo "Chain Length does not match with available img files"
	exit 1
fi

if [ $chainLen -ne "$metaCnt" ]; then
	echo "Chain Length does not match with available meta files"
	exit 1
fi

echo "No discrepancies found among the files in this replica"
