# OpenEBS Helm Repository

<img width="300" align="right" alt="OpenEBS Logo" src="https://raw.githubusercontent.com/cncf/artwork/master/projects/openebs/stacked/color/openebs-stacked-color.png" xmlns="http://www.w3.org/1999/html">

## Charts

### OpenEBS

[Helm](https://helm.sh) must be installed to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```console
$ helm repo add openebs https://openebs.github.io/charts
```

You can then run `helm search repo openebs` to see the charts.

#### Using Helm 3

First, create the namespace: `kubectl create namespace <OPENEBS NAMESPACE>`

```bash
helm install openebs --namespace <YOUR NAMESPACE>
```

#### Using Helm 2

```bash
helm install openebs --namespace <YOUR NAMESPACE>
```

For more details on installing OpenEBS please see the [chart readme](https://github.com/openebs/charts/blob/master/charts/openebs/README.md).

