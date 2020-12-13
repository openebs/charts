# OpenEBS Helm Chart and other artifacts

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Lint and Test Charts](https://github.com/openebs/charts/workflows/Lint%20and%20Test%20Charts/badge.svg?branch=master)](https://github.com/openebs/charts/actions)
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fopenebs%2Fcharts.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2Fopenebs%2Fcharts?ref=badge_shield)

The content in this repository is published using GitHub pages at https://openebs.github.io/charts/. 

This repository contains OpenEBS Helm charts and other example artifacts like openebs-operator.yaml or example YAMLs. 

## OpenEBS Helm Chart

The helm chart is located under [./charts/](./charts/) directory. 

When new changes to helm chart are pushed to master branch, the changes are picked up by [Helm Chart releaser](https://github.com/helm/chart-releaser-action) GitHub Action. The chart releaser will: 
- Upload the new version of the charts to the [GitHub releases](https://github.com/openebs/charts/releases).
- Update the helm repo index file and push to the [GitHub Pages branch](https://github.com/openebs/charts/tree/gh-pages).

## Mayastor Helm Chart

Helm chart for Mayastor is currently maintained [along the Mayastor code-base](https://github.com/openebs/Mayastor/tree/develop/chart). Please, note, that it is being actively developed and can change or break without warning.

## OpenEBS Artifacts

This is a collection of YAMLs or scripts that help to perform some OpenEBS tasks like:
- YAML file to setup OpenEBS via kubectl.
- Scripts to push the OpenEBS container images to a custom registry for air-gapped environments. 
- and more. 

The artifacts are located in the [GitHub Pages(gh-pages) branch](https://github.com/openebs/charts/tree/gh-pages).

## Contributing

See [./CONTRIBUTING.md](./CONTRIBUTING.md).

## License

[Apache 2.0 License](./LICENSE).


[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fopenebs%2Fcharts.svg?type=large)](https://app.fossa.com/projects/git%2Bgithub.com%2Fopenebs%2Fcharts?ref=badge_large)
