#!/bin/sh

kubectl create -f manifests/tiller-rbac-config.yaml
helm init --upgrade --service-account tiller
