# Monitor OpenEBS volumes and pools

### Prerequisites
* OpenEBS installed
* OpenEBS Volumes created(up and running)

### Steps 
* When applying the configs using [openebs-monitoring-pg.yaml](https://raw.githubusercontent.com/Ab-hishek/openebs-monitoring/master/openebs-monitoring-pg.yaml):
1. Run kubectl apply -f [openebs-monitoring-pg.yaml](https://raw.githubusercontent.com/Ab-hishek/openebs-monitoring/master/openebs-monitoring-pg.yaml)
2. Run `kubectl get pods -n openebs -o wide` to verify and to get where Prometheus and Grafana instances are running.
3. Run `kubectl get nodes -o wide` to get the node’s IP.
4. Run `kubectl get svc -n openebs` and note down the port allocated to Prometheus and Grafana services.
5. Open your browser and open `<nodeip:nodeport>`(32514 for Prometheus and 32515 for Grafana) and you should be able to see the Prometheus’s expression browser and Grafana’s UI on your browser.
6. Login into it(default username and password is admin), add data source name as DS_OPENEBS_PROMETHEUS, select datasource type Prometheus and pass the `<nodeip:nodeport>`of Prometheus in the url field and click on run and test.
7. Now go to the next tab (Dashboard) and import the desired dashboard.You should be able to get preloaded dashboard of prometheus.
8. To create openebs dashboard, go to the import and paste the json from this folder.
9. You should be able to get the graph of openebs volumes in the UI.

* When using default Prometheus setup(or your own setup):
It can be done in 2 ways. First way is to follow the 9 steps given below or the second way is the add the custom rules for `openebs-volumes`, `openebs-pools` and `pv-exporter` to let Prometheus scrape metrics from them. For the later way you can refer to the `openebs-volumes`, `openebs-pools` and `pv-exporter` jobs described inside the `openebs-monitoring-pg.yaml`.

1. Make sure that the cStor target pods or any other volumes(jiva or localpv) created by OpenEBS storage engines have the following annotations added to them:
```
prometheus.io/scrape: 'true'
prometheus.io/path: '/data/metrics'
prometheus.io/port: '80'
```
If not present add the above annotations to let Prometheus monitor custom kubernetes pods.

By default the VolumeMonitor is set to ON in the cStor and Jira StorageClass. Volume metrics are exported when this parameter is set to ON. Grafana charts can be built for the above Prometheus metrics. Refer: [monitor-jira-volume](https://docs.openebs.io/docs/next/jivaguide.html#monitoring-a-jiva-volume) & [monitor-cstor-volume](https://docs.openebs.io/docs/next/ugcstor.html#monitoring-a-cStor-Volume).   
Also note that `maya-volume-exporter` runs as sidecar in volume-controller which is invoked automatically while provisioning volume.

#### How will the above annotation work?
Look at the kubernetes-pods job of config-map.yaml you are using to configure prometheus,
```
- job_name: 'kubernetes-pods'

        kubernetes_sd_configs:
        - role: pod

        relabel_configs:
        - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
          action: keep
          regex: true
        - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
          action: replace
          target_label: __metrics_path__
          regex: (.+)
        - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
          action: replace
          regex: ([^:]+)(?::\d+)?;(\d+)
          replacement: $1:$2
          target_label: __address__
        - action: labelmap
          regex: __meta_kubernetes_pod_label_(.+)
        - source_labels: [__meta_kubernetes_namespace]
          action: replace
          target_label: kubernetes_namespace
        - source_labels: [__meta_kubernetes_pod_name]
          action: replace
          target_label: kubernetes_pod_name
```
Check this three relabel configuration
```
- source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
    action: keep
    regex: true
- source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
    action: replace
    target_label: __metrics_path__
    regex: (.+)
- source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
    action: replace
    regex: ([^:]+)(?::\d+)?;(\d+)
    replacement: $1:$2
    target_label: __address__
```
Here, `__metrics_path__` and `port` and whether to scrap metrics from this pod are being read from pod annotations.

2. Run `kubectl get nodes -o wide` to get the node’s IP.
3. Run `kubectl get svc -n <namespace>` and note down the port allocated to Prometheus and Grafana services. Here `<namespace>` must be replaced with the namespace in which the Prometheus and Grafana services are running. If the services are not already created then create a new NodePOrt service for both of them.
4. Open your browser and open `<nodeip:nodeport>`(for Prometheus and Grafana) and you should be able to see the Prometheus’s expression browser and Grafana’s UI on your browser.
5. Login into it(default username and password is admin), add data source name as DS_OPENEBS_PROMETHEUS, select datasource type Prometheus and pass the `<nodeip:nodeport>`of Prometheus in the url field and click on run and test.
6. Now go to the next tab (Dashboard) and import the desired dashboard.You should be able to get preloaded dashboard of prometheus.
7. For the dashboards, some changes need to be made in their respective json files. Replace the query in the dashboard's template section in the following way:   
replace `storage_pool_claim` with `openebs_io_cstor_pool_cluster` or `openebs_io_storage_pool_claim` depending on the OpenEBS version   
replace `cstor_pool` with `openebs_io_cstor_pool_instance` or `openebs_io_cstor_pool` depending on the OpenEBS version   
replace `openebs_pv` with `openebs_io_persistent_volume`   
replace `openebs_pvc` with `openebs_io_persistent_volume_claim`   

For localpv dashboard:   
replace `openebs_pv` with `persistentvolume`   
replace `openebs_pvc` with `persistentvolumeclaim`  

8. To create openebs dashboard, go to the import and paste the json from this folder.
9. You should be able to get the graph of openebs volumes in the UI.

**Note:** For localpv volumes you will have to add a pv-exporter to your cluster that will help scrape the localpv volume metrics.
#### pv-exporter yaml:
```
# node-exporter will be launch as daemonset.
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: pv-exporter
  namespace: openebs
spec:
  selector: 
    matchLabels: 
      app: pv-exporter
  template:
    metadata:
      labels:
        app: pv-exporter
        name: pv-exporter
    spec:
      containers:
      #- image: prom/node-exporter:v0.18.1
      - image: prom/node-exporter:v0.18.1
        args:
          - --path.procfs=/host/proc
          - --path.sysfs=/host/sys
          - --path.rootfs=/host/root
          - --collector.filesystem.ignored-mount-points=^/(dev|proc|sys|var/lib|run|boot|home/kubernetes/.+)($|/)
          - --collector.filesystem.ignored-fs-types=^(autofs|binfmt_misc|cgroup|configfs|debugfs|devpts|devtmpfs|fusectl|hugetlbfs|mqueue|overlay|proc|procfs|pstore|rpc_pipefs|securityfs|sysfs|tracefs)$
          - --collector.textfile.directory=/shared_vol
        name: node-exporter
        ports:
        - containerPort: 9100
          # hostPort: 9100
          name: scrape
        resources:
            requests:
              memory: "128M"
              cpu: "128m"
            limits:
              memory: "250M"
              cpu: "250m"
        volumeMounts:
        # All the application data stored in data-disk
        - name: proc
          mountPath: /host/proc
          readOnly: false
        # Root disk is where OS(Node) is installed
        - name: sys
          mountPath: /host/sys
          readOnly: false
        - name: root
          mountPath: /host/root
          mountPropagation: HostToContainer
          readOnly: true
      - name: pv-monitor
        image: openebs/monitor-pv:0.2.0
        imagePullPolicy: IfNotPresent
        env:
          - name: TEXTFILE_PATH
            value: /shared_vol
          - name: COLLECT_INTERVAL 
            value: "60"
          - name: PROVISIONER_WHITELIST
            value: "openebs.io/local"
        command:
        - /bin/bash
        args:
        - -c
        - ./textfile_collector.sh
        volumeMounts:
        - mountPath: /host/proc
          name: proc
        - mountPath: /host/sys
          name: sys
        - mountPath: /host/root
          mountPropagation: HostToContainer
          name: root
          readOnly: true
      tolerations:
      - effect: NoSchedule
        operator: Exists
      volumes:
        - name: proc
          hostPath:
            path: /proc
        - name: sys
          hostPath:
            path: /sys
        - name: root
          hostPath:
            path: /
      # hostNetwork: true
      hostPID: true
      # The Kubernetes scheduler’s default behavior works well for most cases
      # -- for example, it ensures that pods are only placed on nodes that have 
      # sufficient free resources, it ties to spread pods from the same set 
      # (ReplicaSet, StatefulSet, etc.) across nodes, it tries to balance out 
      # the resource utilization of nodes, etc.
      #
      # But sometimes you want to control how your pods are scheduled. For example,
      # perhaps you want to ensure that certain pods only schedule on nodes with 
      # specialized hardware, or you want to co-locate services that communicate 
      # frequently, or you want to dedicate a set of nodes to a particular set of 
      # users. Ultimately, you know much more about how your applications should be
      # scheduled and deployed than Kubernetes ever will.
      #
      # “taints and tolerations,” allows you to mark (“taint”) a node so that no 
      # pods can schedule onto it unless a pod explicitly “tolerates” the taint.
      # toleration  is particularly useful for situations where most pods in 
      # the cluster should avoid scheduling onto the node. In our case we want
      # node-exporter to run on master node also i.e, we want to collect metrics 
      # from master node. That's why tolerations added.
      # if removed master's node metrics can't be scrapped by prometheus.
      tolerations:
      - effect: NoSchedule
        operator: Exists
      volumes:
        # A hostPath volume mounts a file or directory from the host node’s 
        # filesystem.For example, some uses for a hostPath are:
        # running a container that needs access to Docker internals; use a hostPath 
        # of /var/lib/docker
        # running cAdvisor in a container; use a hostPath of /dev/cgroups
        - name: proc
          hostPath:
            path: /proc
        - name: sys
          hostPath:
            path: /sys
        - name: root
          hostPath:
            path: /
      hostNetwork: true
      hostPID: true
```

### Note: For Storage Pool Dashboard and LocalPV Dashboard you will need to provide variables manually in the query params of the dashboard URL.

#### For Storage pool dashboard, the Grafana URL looks like this:  
http://localhost:3000/d/5d86b1fd-b2e7-4bb2-befa-4dae5b6167d6/storage-pool-dashboard?var-pool=cstorpool-abhishek-dh27&var-kind=CStorPoolCluster&orgId=1  
* Name - Storage Pool Dashboard  
* UID- 5d86b1fd-b2e7-4bb2-befa-4dae5b6167d6  
* Query Params :-  
  1. var-pool  
  2. var-kind  

#### For LocalPV dashboard, the Grafana URL looks like this:  
http://localhost:3000/d/2e59785a-af05-465e-b9a3-fca65a0e8572/localpv-dashboard?refresh=1m&var-openebs_volume=kubera-demo-minio-pv-claim&var-pvcname=kubera-demo-minio-pv-claim&var-namespace=default&var-storageclass=openebs-hostpath&var-type=local-hostpath&var-orgId=1&orgId=1  
* Name - LocalPV dashboard  
* UID - 2e59785a-af05-465e-b9a3-fca65a0e8572  
* Query Params :-  
  1. var-openebs_volume  
  2. var-pvcname  
  3. var-namespace  
  4. var-storageclass  
  5. var-type  
