#!/bin/bash

usage()
{
	echo "Usage: bash get_all_logs.sh <application_pod> <application_pod_namespace> <output_file>"
	echo "Note: This script doesn't do any kind of input validation, and, also, doesn't modify the cluster"
	exit 1
}

get_kubectl_cmds_output()
{
	app_pod=$1
	app_ns=$2
	operator_ns="openebs"

	echo "app_pod: "$app_pod" app_pod_ns:"$app_ns" operator_ns:"$operator_ns

	echo "All the pods in openebs ns:"
	kubectl get pods -n openebs --show-labels -o wide -a

	echo "All the pods in maya-system ns:"
	kubectl get pods -n maya-system --show-labels -o wide -a

	echo "Get the application PVC"
	app_pvc=`kubectl get pod $app_pod -n $app_ns --no-headers -o=jsonpath='{.spec.volumes[*].persistentVolumeClaim.claimName}'`
	echo $app_pvc

	echo "Get the PV of PVC"
	pv=`kubectl get pvc $app_pvc -o custom-columns=:spec.volumeName -n $app_ns --no-headers`
	echo $pv

	echo "Get the target pod"
	tgt_pod=`kubectl get pod -n $operator_ns -l openebs.io/persistent-volume=$pv --no-headers -o=jsonpath='{.items[0].metadata.name}'`
	echo $tgt_pod

	echo "Describe target pod "$tgt_pod":"
	kubectl describe pod $tgt_pod -n $operator_ns

	echo "Get target pod "$tgt_pod" in json:"
	kubectl get pod $tgt_pod -n $operator_ns -o json

	echo "Get the pool deployment list"
	pool_deployment_list=`kubectl get cvr -n $operator_ns -l openebs.io/persistent-volume=$pv --no-headers -o=jsonpath='{range .items[*]}{.metadata.labels.cstorpool\.openebs\.io\/name}{"\n"}{end}'`
	echo $pool_deployment_list

	for pool_deployment in $pool_deployment_list
	do
		pool_pod=`kubectl get pods -n $operator_ns | grep -w $pool_deployment | grep -w "Running" | awk '{print $1}'`

		echo "Describe pool pod "$pool_pod":"
		kubectl describe pod $pool_pod -n $operator_ns

		echo "Get pool pod "$pool_pod" in json:"
		kubectl get pod $pool_pod -n $operator_ns -o json
	done
}

get_all_logs()
{
	echo "Print application "$app_pod" logs:"
	kubectl logs $app_pod -n $app_ns

	echo "Print application "$app_pod" previous instance logs:"
	kubectl logs $app_pod -n $app_ns -p

	echo "netstat output of target pod "$tgt_pod":"
	kubectl exec -it $tgt_pod -n $operator_ns -c cstor-istgt -- netstat -nap

	echo "istgt conf output of target pod "$tgt_pod":"
	kubectl exec -it $tgt_pod -n $operator_ns -c cstor-istgt -- cat /usr/local/etc/istgt/istgt.conf

	echo "Print target pod "$tgt_pod" logs:"
	kubectl logs $tgt_pod -c cstor-istgt -n $operator_ns

	echo "Print target pod "$tgt_pod" previous instance logs:"
	kubectl logs $tgt_pod -c cstor-istgt -n $operator_ns -p

	for pool_deployment in $pool_deployment_list
	do
		pool_pod=`kubectl get pods -n $operator_ns | grep -w $pool_deployment | grep -w "Running" | awk '{print $1}'`

		echo "netstat output of pool pod "$pool_pod":"
		kubectl exec -it $pool_pod -n $operator_ns -c cstor-pool -- netstat -nap

		echo "zpool output of pool pod "$pool_pod":"
		kubectl exec -it $pool_pod -n $operator_ns -c cstor-pool -- zpool list

		echo "zfs output of pool pod "$pool_pod":"
		kubectl exec -it $pool_pod -n $operator_ns -c cstor-pool -- zfs list -t all

		echo "Print pool pod "$pool_pod" logs:"
		kubectl logs $pool_pod -c cstor-pool -n $operator_ns

		echo "Print pool pod "$pool_pod" previous instance logs:"
		kubectl logs $pool_pod -c cstor-pool -n $operator_ns -p
	done
}

if [ $# -ne 3 ]; then
	usage
fi

get_kubectl_cmds_output $1 $2 > $3 2>&1

sed -i.bak 's/\b[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\b/IP-MASK/g' $3

get_all_logs >> $3 2>&1

