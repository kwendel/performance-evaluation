# CS4215 - Quantitative Performance Evaluation for Computing Systems

## Installing istio
- Download the latest release from istio from github, 1.3.1 as of writing
- Extract into the root of the project
- Install istio on the cluster you're connected to with `./scripts/deploy-cluster.yaml`

## Installing helm
- Install helm with `brew install kubernetes-helm`, or for other setups see [GitHub](https://github.com/helm/helm)
- Install Tiller (the server component of helm) and the corresponding namespace & serviceaccount on the cluster you're connect to with `./scripts/init-helm.sh`

## Install spark
- Deploy a spark master pod and three workers with `./scripts/deploy-spark.sh` (This script still needs to be tested)
- Deploy a spark master pod with three worker replications at once with `helm install --debug qpe --values qpe/values.yaml --name test --namespace spark`
  - Deploy individual templates with `helm template qpe -x templates/spark-master-deployment.yaml --values qpe/values.yaml --name test --namespace spark`

## TODO: Submit a job
