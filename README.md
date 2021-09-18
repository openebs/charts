# OpenEBS Helm Chart and other artifacts

[![Lint and Test Charts](https://github.com/openebs/charts/workflows/Lint%20and%20Test%20Charts/badge.svg?branch=main)](https://github.com/openebs/charts/actions)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fopenebs%2Fcharts.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2Fopenebs%2Fcharts?ref=badge_shield)
[![Slack](https://img.shields.io/badge/chat!!!-slack-ff1493.svg?style=flat-square)](https://kubernetes.slack.com/messages/openebs)


<img width="200" align="right" alt="OpenEBS Logo" src="https://raw.githubusercontent.com/cncf/artwork/HEAD/projects/openebs/stacked/color/openebs-stacked-color.png" xmlns="http://www.w3.org/1999/html">


This repository contains OpenEBS Helm charts and other example artifacts like openebs-operator.yaml or example YAMLs. The content in this repository is published using GitHub pages at https://openebs.github.io/charts/. 

## OpenEBS Helm Chart

The helm chart is located under [./charts/openebs/](./charts/openebs/) directory. 

OpenEBS helm chart is an umbrella chart that pulls together engine specific charts. The engine charts are included as dependencies in [Chart.yaml](charts/openebs/Chart.yaml).

OpenEBS helm chart will includes common components that are used by multiple engines like:
- Node Disk Manager related components
- Dynamic LocalPV (hostpath and device) Provisioner related components
- Security Policies like RBAC, PSP, Kyverno 

Engine charts included as dependencies are:
- [cStor](https://github.com/openebs/cstor-operators/tree/HEAD/deploy/helm/charts)
- [Jiva](https://github.com/openebs/jiva-operator/tree/HEAD/deploy/helm/charts)
- [ZFS Local PV](https://github.com/openebs/zfs-localpv/tree/HEAD/deploy/helm/charts)
- [LVM Local PV](https://github.com/openebs/lvm-localpv/tree/HEAD/deploy/helm/charts)
- [Dynamic NFS](https://github.com/openebs/dynamic-nfs-provisioner/tree/develop/deploy/helm/charts)

Some of the other charts that will be included in the upcoming releases are:
- [Rawfile Local PV](https://github.com/openebs/rawfile-localpv/tree/HEAD/deploy/charts/rawfile-csi)
- [Mayastor](https://github.com/openebs/mayastor/tree/develop/chart)
- [Dashboard](https://github.com/openebs/monitoring/tree/develop/deploy/charts/openebs-monitoring)

> **Note:** cStor and Jiva out-of-tree provisioners will be replaced by respective CSI charts listed above. OpenEBS users are expected to install the cstor and jiva CSI components and migrate the pools and volumes. The steps to migate are available at: https://github.com/openebs/upgrade

### Releasing a new version 

- Raise a PR with the required changes to the HEAD branch. 
- Tag the [maintainers](./MAINTAINERS) for review
- Once changes are reviewed and merged, the changes are picked up by [Helm Chart releaser](https://github.com/helm/chart-releaser-action) GitHub Action. The chart releaser will: 
  - Upload the new version of the charts to the [GitHub releases](https://github.com/openebs/charts/releases).
  - Update the helm repo index file and push to the [GitHub Pages branch](https://github.com/openebs/charts/tree/gh-pages).


## OpenEBS Artifacts

The artifacts are located in the [GitHub Pages(gh-pages) branch](https://github.com/openebs/charts/tree/gh-pages).

The files can be accessed either as github rawfile or as hosted files. Example, openebs operator can be used as follows:
- As github raw file URL:
  ```
  kubectl apply -f https://raw.githubusercontent.com/openebs/charts/gh-pages/openebs-operator.yaml
  ```
- As hosted URL:
  ```
  kubectl apply -f https://openebs.github.io/charts/openebs-operator.yaml
  ```

This is a collection of YAMLs or scripts that help to perform some OpenEBS tasks like:
- YAML file to setup OpenEBS via kubectl.
  - [OpenEBS Commons Operator](https://github.com/openebs/charts/blob/gh-pages/openebs-operator.yaml)
  - [OpenEBS cStor](https://github.com/openebs/charts/blob/gh-pages/cstor-operator.yaml)
  - [OpenEBS Jiva](https://github.com/openebs/charts/blob/gh-pages/jiva-operator.yaml)
  - [OpenEBS Hostpath](https://github.com/openebs/charts/blob/gh-pages/hostpath-operator.yaml) 
  - [OpenEBS Hostpath and Device](https://github.com/openebs/charts/blob/gh-pages/openebs-operator-lite.yaml)
  - [OpenEBS LVM Local PV](https://github.com/openebs/charts/blob/gh-pages/lvm-operator.yaml)
  - [OpenEBS ZFS Local PV](https://github.com/openebs/charts/blob/gh-pages/zfs-operator.yaml)
  - [OpenEBS NFS PV](https://github.com/openebs/charts/blob/gh-pages/nfs-operator.yaml)
- YAML file to install OpenEBS prerequisties on hosts via nsenter pods via kubectl.
  - [Setup iSCSI on Ubuntu](https://github.com/openebs/charts/blob/gh-pages/openebs-ubuntu-setup.yaml)
  - [Setup iSCSI on Amazon Linux](https://github.com/openebs/charts/blob/gh-pages/openebs-amazonlinux-setup.yaml)
- Scripts to push the OpenEBS container images to a custom registry for air-gapped environments. 
- and more. 


## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md).

## Community, discussion, and support

You can reach the maintainers of this project at:

- [Kubernetes Slack](http://slack.k8s.io/) channels: 
      * [#openebs](https://kubernetes.slack.com/messages/openebs/)
      * [#openebs-dev](https://kubernetes.slack.com/messages/openebs-dev/)
- [Mailing List](https://lists.cncf.io/g/cncf-openebs-users)

For more ways of getting involved with community, check our [community page](https://github.com/openebs/openebs/tree/HEAD/community).

### Code of conduct

Participation in the OpenEBS community is governed by the [CNCF Code of Conduct](./CODE-OF-CONDUCT.md).



## License

[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fopenebs%2Fcharts.svg?type=large)](https://app.fossa.com/projects/git%2Bgithub.com%2Fopenebs%2Fcharts?ref=badge_large)
