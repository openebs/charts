## Kyverno Policy Integration

PodSecurityPolicy(PSP) is being deprecated in Kubernetes v1.21 and will be removed in v1.25. So, the suitable alternative is Kyverno.

<img width="130" align="right" alt="Kyverno Logo" src="https://github.com/cncf/artwork/blob/master/projects/kyverno/stacked/color/kyverno-stacked-color.png" xmlns="http://www.w3.org/1999/html">

Kyverno is an Open source policy engine designed specifically for Kubernetes. The word "Kyverno" is a Greek word for "Govern". It was originally developed by Nirmata and is now a CNCF sandbox project. It can validate, mutate, and generate configurations using admission controls and background scans.

The list of tthe following policies:

| Control                        | Description                                   | Policies                                  |
| -------------------------------| --------------------------------------------- | ----------------------------------------- |
| Capabilities                   | allowedCapabilities is a list of capabilities that can be requested to add to the container.| [Allow Capabilities](https://github.com/openebs/charts/blob/main/charts/openebs/templates/kyverno/allow-capabilities.yaml)   |
| Host Namespaces                | hostNamespaces allow access to shared information and can be used to elevate privileges.| [Allow Host Namespaces](https://github.com/openebs/charts/blob/main/charts/openebs/templates/kyverno/allow-host-namespaces.yaml) |
| Host Ports                     | hostPorts determines which host port ranges are allowed to be exposed.| [Allow Host Ports](https://github.com/openebs/charts/blob/main/charts/openebs/templates/kyverno/allow-host-ports.yaml)|
| Privilege Escalation           | allowPrivilegeEscalation determines if a pod can request to allow privilege escalation. If unspecified, defaults to true.| [Allow Privilege Escalation](https://github.com/openebs/charts/blob/main/charts/openebs/templates/kyverno/allow-privilege-escalation.yaml)|
| Privilege Container            | hostPorts determines which host port ranges are allowed to be exposed.| [Allow Privilege Containers](https://github.com/openebs/charts/blob/main/charts/openebs/templates/kyverno/allow-privileged-containers.yaml) |
| SELinux                        | seLinux is the strategy that will dictate the allowable labels that may be set. | [Allow SELinux](https://github.com/openebs/charts/blob/main/charts/openebs/templates/kyverno/allow-selinux.yaml) |
| /proc Mount Type               | allowProcMountTypes is an allowlist of allowed ProcMountTypes. This is set up to reduce attack surfaces.| [Require Default Proc Mount](https://github.com/openebs/charts/blob/main/charts/openebs/templates/kyverno/allow-proc-mount.yaml)|
| User groups                    | userGroups all processes inside pod can be made to run with specific user and groupID by setting ‘runAsUser’, ‘supplementalGroup’ and ‘fsGroup’ respectively. | [Require User Groups](https://github.com/openebs/charts/blob/main/charts/openebs/templates/kyverno/require-user-groups.yaml) |


### Installation

1.Install kyverno via [Helm](https://kyverno.io/docs/installation/#install-kyverno-using-helm) or [YAMLs](https://kyverno.io/docs/installation/#install-kyverno-using-yamls) in Kubernetes cluster.

2.After that install kyverno policies with OpenEBS using flag `rbac.kyvernoEnabled=true`.

`helm install openebs openebs/openebs --namespace openebs --create-namespace --set legacy.enabled=false --set cstor.enabled=true --set openebs-ndm.enabled=true`

3.Check the list of policies which has been created by using.

`kubectl get pol`