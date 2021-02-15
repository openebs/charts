# Monitor OpenEBS volumes and pools

### Prerequisites
* OpenEBS installed
* OpenEBS Volumes created

### Steps
1. Run kubectl apply -f [openebs-monitoring-pg.yaml](https://raw.githubusercontent.com/Ab-hishek/openebs-monitoring/master/openebs-monitoring-pg.yaml)
2. Run `kubectl get pods -o wide` to verify and to get where Prometheus and Grafana instances are running.
3. Run `kubectl get nodes -o wide` to get the node’s IP.
4. Run `kubectl get svc` and note down the port allocated to Prometheus and Grafana services.
5. Open your browser and open `<nodeip:nodeport>`(32514 for Prometheus and 32515 for Grafana) and you should be able to see the Prometheus’s expression browser and Grafana’s UI on your browser.
6. Login into it(default username and password is admin), add data source name as prometheus, select datasource type Prometheus and pass the `<nodeip:nodeport>`of Prometheus in the url field and click on run and test.
7. Now go to the next tab (Dashboard) and import the desired dashboard.You should be able to get preloaded dashboard of prometheus.
8. To create openebs dashboard, go to the import and paste the json from this folder.
9. You should be able to get the graph of openebs volumes in the UI.

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
