#!/bin/bash

kubectl create -f manifests/spark-rbac-config.yaml

mastername="test-master"
workername="test-worker"
namespace="spark"

helm install qpe/master --set Master.Fullname=$mastername --name $mastername --namespace $namespace

for i in {1..3}; do
    name=${workername}-${i}
    helm install qpe/worker --set Worker.Fullname=$name --name $name --namespace $namespace
done
