#!/bin/sh

kubectl create -f manifest/tiller-rbac-config.yaml
helm init --upgrade --service-account tiller
