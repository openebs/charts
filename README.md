# Charts

## ⚠️ Deprecation Notice: Helm Chart Registry Migration

The Helm chart registry at "https://openebs.github.io/charts" is deprecated and will be moved to a new location soon.

**Old Registry URL:** https://openebs.github.io/charts  
**New Registry URL:** https://openebs.github.io/openebs  

To ensure seamless access to OpenEBS Helm charts, update your configurations to use the new registry URL.

Additionally, the older registry will be relocated to the [openebs-archive](https://github.com/openebs-archive) GitHub organization.

**Relocation Deadline:** October 30th, 2024

Refer to the [OpenEBS documentation](https://openebs.io/docs) for more information and guidance on this migration.

Thank you for your attention to this matter. If you have any questions or need assistance with the migration, reach out to the [OpenEBS community](https://openebs.io/community).

-----------------------------

The contents of this branch (gh-pages) are published via GitHub pages at https://openebs.github.io/charts/

This branch contains the following:
- OpenEBS Helm Chart metadata - [index.yaml](./index.yaml). This file is auto-updated by GitHub Action - Helm Chart Releaser. Please do not modify this file. 
- [Example YAMLs](./examples/) used in OpenEBS Documentation.
- Various [Scripts](./scripts) that automate one-time operations like syncing OpenEBS container images to local repository or to perform trivy scanning on the container images. 
- Sample YAMLs used to setup/install OpenEBS via `kubectl`. 

