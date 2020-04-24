#!/bin/bash

infra_hosts=`kubectl --no-headers=true get pod -n openebs -owide | awk '{print $7}' | sort -u`
echo OpenEBS Enterprise Infrastructure hosts:
echo $infra_hosts
echo OpenEBS Enterprise Infrastructure consumers:

kubectl --no-headers=true get pvc -A -o 'custom-columns=NAMESPACE:metadata.namespace,NAME:metadata.name,ANNOTATIONS:metadata.annotations' | tr ']' ' ' | while read namespace name rest
do
		for word in $rest
		do
				case "$word" in
						 *kubernetes.io/storage-provisioner:*)
								 provisioner=`echo $word | tr ':' ' ' | awk '{print $2}'`
								 
																						;;
						 *kubernetes.io/selected-node:*)
								 node=`echo $word | tr ':' ' ' | awk '{print $2}'`
								 
																						;;
  			esac
		done
		case "$provisioner" in
				*openebs.io*)
						client_count=`expr $client_count + 1`
						echo $node
						;;
		esac
done >3
consumers=`sort -u <3`
echo $consumers
all_hosts=`echo $consumers $infra_hosts | tr ' ' '\n' | sort -u`
count=`echo $all_hosts | wc -w`
echo $count total OpenEBS Licenses in use
