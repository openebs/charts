
# Kubernetes Helm Charts for OpenEBS

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Lint and Test Charts](https://github.com/openebs/charts/workflows/Lint%20and%20Test%20Charts/badge.svg?branch=master)](https://github.com/openebs/charts/actions)

# Usage

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
helm install openebs --namespace <YOUR NAMESPACE> helm install stable/openebs
```

#### Using Helm 2

```bash
helm install openebs --namespace <YOUR NAMESPACE>
```

## License

[Apache 2.0 License](./LICENSE).