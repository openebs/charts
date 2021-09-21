#!/bin/bash
# Copyright 2021 The OpenEBS Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e


rm -rf test-openebs-operator.yaml
## create the operator file using all the yamls
echo "# This manifest deploys the OpenEBS control plane components, 
# with associated CRs & RBAC rules
# NOTE: On GKE, deploy the openebs-operator.yaml in admin context
#
# NOTE: The Jiva and cStor components included in the Operator File will be deprecated 
#  with 3.0 in favor of the following cStor and Jiva CSI operators. To upgrade your Jiva
#  and cStor volumes to CSI, please checkout the documentation at:
#  https://github.com/openebs/upgrade
#
# To deploy cStor CSI:
# kubectl apply -f https://openebs.github.io/charts/cstor-operator.yaml
#
# To deploy Jiva CSI:
# kubectl apply -f https://openebs.github.io/charts/jiva-operator.yaml
#
" > test-openebs-operator.yaml

# create the openebs-operator.yaml manifest
{
  # Add namespace creation
  cat yamls/namespace.yaml

  # Add RBAC
  cat yamls/rbac.yaml

  # Add the legacy-provisioner
  cat yamls/legacy-provisioner.yaml

  # Add the ndm
  cat yamls/ndm-operator.yaml

  # Add the local-provisioner
  cat yamls/local-hostpath-provisioner.yaml
} >> test-openebs-operator.yaml

