# OpenEBS Helm Repository

<img width="300" align="right" alt="OpenEBS Logo" src="https://raw.githubusercontent.com/cncf/artwork/master/projects/openebs/stacked/color/openebs-stacked-color.png" xmlns="http://www.w3.org/1999/html">

[Helm](https://helm.sh) must be installed to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```bash
helm repo add openebs https://openebs.github.io/charts
```

You can then run `helm search repo openebs` to see the charts.

#### Update OpenEBS Repo

Once OpenEBS repository has been successfully fetched into the local system, it has to be updated to get the latest version. The OpenEBS repo can be updated using the following command.

```bash
helm repo update
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

For more details on installing OpenEBS please see the [chart readme](https://github.com/openebs/charts/blob/master/charts/openebs/README.md).
