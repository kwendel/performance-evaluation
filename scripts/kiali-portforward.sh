#!/bin/bash

echo "Forwarding kiali to http://localhost:20001"
echo ""
kubectl port-forward -n istio-system $(kubectl get pods -l app=kiali -n istio-system -o jsonpath="{.items[0].metadata.name}") 20001:20001
