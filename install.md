### Login to the cluster
gcloud init
gcloud container clusters get-credentials <..> (see cloud console cluster page)


### Install Tiller SA and Role bindings
kubectl create -f manifests/tiller-rbac-config.yaml

### Setup tiller on the cluster
helm init --upgrade --service-account tiller

### Install Spark SA and Role bindings
kubectl create -f manifests/spark-rbac-config.yaml

### NOT NEEDED: Install Kubernetes Operator for Spark
helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
helm install incubator/sparkoperator --name spark-operator --namespace spark-operator

### Get helm dependencies if missing
helm dep up

### Deploy charts on cluster
helm install --debug ./qpe --name test --namespace spark

### Delete helm charts
helm delete --purge test
