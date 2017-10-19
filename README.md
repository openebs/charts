# OpenEBS Helm Charts

## Prerequisites
- Install Helm
  On Ubuntu, you can install as follows:
  ```
  curl -Lo /tmp/helm-linux-amd64.tar.gz https://kubernetes-helm.storage.googleapis.com/helm-v2.6.2-linux-amd64.tar.gz
  tar -xvf /tmp/helm-linux-amd64.tar.gz -C /tmp/
  chmod +x  /tmp/linux-amd64/helm && sudo mv /tmp/linux-amd64/helm /usr/local/bin/
  ```

- Package latest version of openebs 
  ```
  git clone https://github.com/openebs/openebs.git
  helm package openebs/k8s/charts/openebs
  ```

## Update with new openebs chart

```
git clone https://github.com/openebs/charts.git
cd charts
mv ../openebs/openebs-0.0.1.tgz ./docs
helm repo index docs --url https://openebs.github.com/charts
```

## References
- https://github.com/kubernetes/helm/blob/master/docs/chart_repository.md
