# OpenEBS Helm Repository

<img width="200" align="right" alt="OpenEBS Logo" src="https://raw.githubusercontent.com/cncf/artwork/master/projects/openebs/stacked/color/openebs-stacked-color.png" xmlns="http://www.w3.org/1999/html">

[OpenEBS](https://openebs.io) helps Developers and Platform SREs easily deploy Kubernetes Stateful Workloads that require fast and highly reliable container attached storage. OpenEBS can be deployed on any Kubernetes cluster - either in cloud, on-premise (virtual or bare metal) or developer laptop (minikube).

OpenEBS Data Engines and Control Plane are implemented as micro-services, deployed as containers and orchestrated by Kubernetes itself. An added advantage of being a completely Kubernetes native solution is that administrators and developers can interact and manage OpenEBS using all the wonderful tooling that is available for Kubernetes like kubectl, Helm, Prometheus, Grafana, etc.

OpenEBS turns any storage available on the Kubernetes worker nodes into local or distributed Kubernetes Persistent Volumes.
* Local Volumes are accessible only from a single node in the cluster. Pods using Local Volume have to be scheduled on the node where volume is provisioned. Local Volumes are typically preferred for distributed workloads like Cassandra, MongoDB, Elastic, etc that are distributed in nature and have high availability built into them. Depending on the type of storage attached to your Kubernetes worker nodes, you can select from different flavors of Dynamic Local PV - Hostpath, Device, LVM, ZFS or Rawfile.
* Replicated Volumes as the name suggests, are those that have their data synchronously replicated to multiple nodes. Volumes can sustain node failures. The replication also can be setup across availability zones helping applications move across availability zones. Depending on the type of storage attached to your Kubernetes worker nodes and application performance requirements, you can select from Jiva, cStor or Mayastor.

## Documentation and user guides

You can run OpenEBS on any Kubernetes 1.18+ cluster in a matter of minutes. See the [Quickstart Guide to OpenEBS](https://openebs.io/) for detailed instructions.

## Getting started

### How to customize OpenEBS Helm chart?

OpenEBS helm chart is an umbrella chart that pulls together engine specific charts. The engine charts are included as dependencies. 
arts/openebs/Chart.yaml). 
OpenEBS helm chart will includes common components that are used by multiple engines like:
- Node Disk Manager related components
- Dynamic Local Provisioner related components
- Security Policies like RBAC, PSP, Kyverno 

```bash
openebs
├── (default) openebs-ndm
├── (default) localpv-provisioner
├── jiva
├── cstor
├── zfs-localpv
└── lvm-localpv
└── nfs-provisioner
```

To install the engine charts, the helm install must be provided with a engine enabled flag like `cstor.enabled=true` or `zfs-localpv.enabled=true` or by passing a custom values.yaml with required engines enabled.

### Prerequisites

- Kubernetes 1.18+ with RBAC enabled
- When using cstor and jiva engines, iSCSI utils must be installed on all the nodes where stateful pods are going to run. 
- Depending on the engine and type of platform, you may have to customize the values or run additional pre-requisistes. Refer to [documentation](https://openebs.io).

### Setup Helm Repository

Before installing OpenEBS Helm charts, you need to add the [OpenEBS Helm repository](https://openebs.github.io/charts) to your Helm client.

```bash
helm repo add openebs https://openebs.github.io/charts
helm repo update
```

### Installing OpenEBS 

```bash
helm install --name `my-release` --namespace openebs openebs/openebs --create-namespace
```

Examples:
- Assuming the release will be called openebs, the command would be:
  ```bash
  helm install --name openebs --namespace openebs openebs/openebs --create-namespace
  ```

- To install OpenEBS with cStor CSI driver, run
  ```bash
  helm install openebs openebs/openebs --namespace openebs --create-namespace --set cstor.enabled=true
  ```

- To install/enable a new engine on the installed helm release `openebs`, you can run the helm upgrade command as follows:
  ```bash
  helm upgrade openebs openebs/openebs --namespace openebs --reuse-values --set jiva.enabled=true 
  ```

- To disable legacy out of tree jiva and cstor provisioners, run the following command.
  ```bash
  helm upgrade openebs openebs/openebs --namespace openebs --reuse-values --set legacy.enabled=false 
  ```

For more details on customizing and installing OpenEBS please see the [chart readme](https://github.com/openebs/charts/tree/HEAD/charts/openebs/README.md).

### To uninstall/delete instance with release name

```bash
helm ls --all
helm delete `my-release`
```

> **Tip**: Prior to deleting the helm chart, make sure all the storage volumes and pools are deleted.

