# Overview

An [issue](https://github.com/openebs/openebs/issues/2956) was reported on Jiva volumes running OpenEBS version 1.6 and 1.7.  Depending on the order in which the jiva replicas have experienced a restart, it is possible that one or more of the replicas could have lost access to some of the data blocks. And if those replicas become the master replicas, the Kubernetes might recommend a `fsck` which can, in turn, result in all replica's losing access to the data. 

Upgrading to 1.8 will resolve the issue, however, upgrading will involve Jiva replica restarts. These steps explained in this document will help determine if the data loss condition has occurred on a jiva volume. If the steps indicate a data loss condition, please reach out to the developers on the slack community to guide you through the upgrade process. 

You can either join our [#openebs Channel on Kubernetes slack](https://kubernetes.slack.com/messages/openebs/). 

The pre-upgrade steps are as follows: 

### Step 1. Download the pre-upgrade script. 

Get the jiva pre-upgrade script, that will validate if the replicas are in a healthy state for the upgrade.
```
wget http://openebs.github.io/charts/scripts/jiva-tools/jiva_preupgrade_checks.sh
```

### Step 2. List the jiva replica pods

Get the list of jiva replicas for the volume being upgraded
```
kubectl get pods -n <pvc-namespace> -l openebs.io/replica=jiva-replica,openebs.io/persistent-volume=<pv-name>
```

### Step 3. Copy pre-upgrade to replica pod and verify

Repeat the following steps for each of the replica listed in Step 2. 

* Copy the script to all the replicas. 
  ```
  kubectl cp -n <pvc-namespace> jiva_preupgrade_checks.sh <replica-pod-name>:/openebs
  ```

* Exec into the replica pod
  ```
  kubectl exec -it -n <pvc-namespace> <replica-pod-name> bash
  ```

* From within the pod, enter the replica data folder
  ```
  :# cd openebs
  ```

* Run the pre-upgrade script
  ```
  :/openebs# bash ./jiva_preupgrade_checks.sh
  ```

  NOTE: Consider setting 'exec' permissions on the file by doing `chmod +x ./jiva_preupgrade_checks.sh`

* Verify that the last line says: `No discrepancies found among the files in this replica`

### Step 4. Determine if the jiva replicas have data loss condition. 

In step 3, if any of the replicas complained of discrepancies between chain length and img/meta files (or) chains length among replicas (or) total used size among replicas, there are chances of data loss and the upgrade has to be performed with the help of developer steps. The upgrade steps will involve further steps in determining which of the replicas may have missing data block access, taking them out of the replica list, upgrading the healthy replica and rebuilding the rouge replicas.

Please provide the debug messages dumped to jiva_preupgrade_checks.out file, *.frag, *.fragout files from all replicas for further debugging.
