# OpenEBS Helm Chart

[OpenEBS](https://github.com/openebs/openebs) is an *open source storage platform* that provides persistent and containerized block storage for DevOps and container environments. 
OpenEBS provides multiple storage engines that can be plugged in easily. A common pattern is the use of OpenEBS to deliver Dynamic LocalPV for those applications and workloads that want to access disks and cloud volumes directly.

OpenEBS can be deployed on any Kubernetes cluster - either in cloud, on-premise or developer laptop (minikube). OpenEBS itself is deployed as just another container on your cluster, and enables storage services that can be designated on a per pod, application, cluster or container level.

## Introduction

This chart bootstraps OpenEBS deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Quickstart and documentation

You can run OpenEBS on any Kubernetes 1.13+ cluster in a matter of seconds. See the [Quickstart Guide to OpenEBS](https://docs.openebs.io/docs/next/quickstart.html) for detailed instructions.

For more comprehensive documentation, start with the [Welcome to OpenEBS](https://docs.openebs.io/docs/next/overview.html) docs.

## Prerequisites

- Kubernetes 1.13+ with RBAC enabled
- iSCSI PV support in the underlying infrastructure

## Adding OpenEBS Helm repository

Before installing OpenEBS Helm charts, you need to add the [OpenEBS Helm repository](https://openebs.github.io/charts) to your Helm client.

```bash
helm repo add openebs https://openebs.github.io/charts
```

## Update the dependent charts

```bash
helm dependency update
```

## Installing OpenEBS

```bash
helm install --namespace openebs openebs/openebs
```

## Installing OpenEBS with the release name

```bash
helm install --name `my-release` --namespace openebs openebs/openebs
```

## To uninstall/delete instance with release name

```bash
helm ls --all
helm delete `my-release`
```

## Configuration

The following table lists the configurable parameters of the OpenEBS chart and their default values.

| Parameter                               | Description                                   | Default                                   |
| ----------------------------------------| --------------------------------------------- | ----------------------------------------- |
| `rbac.create`                           | Enable RBAC Resources                         | `true`                                    |
| `rbac.pspEnabled`                       | Create pod security policy resources          | `false`                                   |
| `cleanup.image.registry`                | Cleanup pre hook image registry               | `nil`                                     |
| `cleanup.image.repository`              | Cleanup pre hook image repository             | `"bitnami/kubectl"`                       |
| `cleanup.image.tag`                     | Cleanup pre hook image tag             | `if not provided determined by the k8s version`                       |
Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
helm install --name openebs -f values.yaml openebs/openebs
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Below charts are dependent charts of this chart
-  [openebs-ndm](https://openebs.github.io/node-disk-manager)
-  [localpv-provisioner](https://openebs.github.io/dynamic-localpv-provisioner)
-  [cstor](https://openebs.github.io/cstor-operators)
-  [jiva](https://openebs.github.io/jiva-operator)
-  [zfs-localpv](https://openebs.github.io/zfs-localpv)
-  [lvm-localpv](https://openebs.github.io/lvm-localpv)

## Dependency tree of this chart
```bash
openebs
├── openebs-ndm
├── localpv-provisioner
│   └── openebs-ndm (optional)
├── jiva
│   └── localpv-provisioner
│       └── openebs-ndm (optional)
├── cstor
│   └── openebs-ndm
├── zfs-localpv
└── lvm-localpv
```

#### (Default) Install Jiva, cStor and Local PV with out-of-tree provisioners
```bash
helm install openebs openebs/openebs --namespace openebs --create-namespace
```

#### Install cStor with CSI driver
```bash
helm install openebs openebs/openebs --namespace openebs --create-namespace \
--set localprovisioner.enabled=false \
--set ndm.enabled=false \
--set ndmOperator.enabled=false \
--set webhook.enabled=false \
--set snapshotOperator.enabled=false \
--set provisioner.enabled=false \
--set apiserver.enabled=false \
--set cstor.enabled=true \
--set openebs-ndm.enabled=true
```

#### Install Jiva with CSI driver
```bash
helm install openebs openebs/openebs --namespace openebs --create-namespace \
--set localprovisioner.enabled=false \
--set ndm.enabled=false \
--set ndmOperator.enabled=false \
--set webhook.enabled=false \
--set snapshotOperator.enabled=false \
--set provisioner.enabled=false \
--set apiserver.enabled=false \
--set jiva.enabled=true \
--set openebs-ndm.enabled=true \
--set localpv-provisioner.enabled=true
```

#### Install ZFS Local PV
```bash
helm install openebs openebs/openebs --namespace openebs --create-namespace \
--set localprovisioner.enabled=false \
--set ndm.enabled=false \
--set ndmOperator.enabled=false \
--set webhook.enabled=false \
--set snapshotOperator.enabled=false \
--set provisioner.enabled=false \
--set apiserver.enabled=false \
--set zfs-localpv.enabled=true
```

#### Install LVM Local PV
```bash
helm install openebs openebs/openebs --namespace openebs --create-namespace \
--set localprovisioner.enabled=false \
--set ndm.enabled=false \
--set ndmOperator.enabled=false \
--set webhook.enabled=false \
--set snapshotOperator.enabled=false \
--set provisioner.enabled=false \
--set apiserver.enabled=false \
--set lvm-localpv.enabled=true
```

#### Install Local PV hostpath and device
```bash
helm install openebs openebs/openebs --namespace openebs --create-namespace \
--set localprovisioner.enabled=false \
--set ndm.enabled=false \
--set ndmOperator.enabled=false \
--set openebs-ndm.enabled=true \
--set localpv-provisioner.enabled=true
```

> **Tip**: You can install multiple csi driver by merging the configuration.
