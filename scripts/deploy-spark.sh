#!/bin/sh

kubectl create -f manifests/spark-rbac-config.yaml

helm template qpe -x templates/spark-master-deployment.yaml --values qpe/values.yaml --namespace spark --name spark-master | kubectl apply -f -

fullname="test-worker"
for index in 1 2 3
do
    workername=${fullname}-${index}

    helm template qpe -x templates/spark-master-deployment.yaml --values qpe/values.yaml --set Worker.Fullname=$workername --namespace spark --name $workername | kubectl apply -f -

done
