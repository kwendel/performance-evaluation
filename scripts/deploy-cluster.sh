#!/bin/sh

kubectl create namespace istio-system

helm template istio-1.3.1/install/kubernetes/helm/istio-init --name istio --namespace istio-system --values=istio-1.3.1/install/kubernetes/helm/istio/values-istio-demo.yaml | kubectl apply -f -

CRDS=""

while [ "$CRDS" != "23" ]; do
    CRDS=$(kubectl get crds | grep 'istio.io' | wc -l)
    echo "Waiting for CRDs to be ready";
    sleep 3
done
echo "CRDs are ready"

helm template istio-1.3.1/install/kubernetes/helm/istio --name istio --namespace istio-system --values=istio-1.3.1/install/kubernetes/helm/istio/values-istio-demo.yaml | kubectl apply -f -

kubectl create namespace spark

# Enable sidecar injection for the spark namespace
kubectl label namespace spark istio-injection=enabled
