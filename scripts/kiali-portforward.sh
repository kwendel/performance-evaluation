#!/bin/bash

echo "Forwarding kiali to http://localhost:8080"
echo ""
kubectl port-forward -n istio-system $(kubectl get pods -l app=kiali -n istio-system -o jsonpath="{.items[0].metadata.name}") 8080:20001
