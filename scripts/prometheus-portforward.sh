#!/bin/bash

echo "Forwarding prometheus to http://localhost:9090"
echo ""
kubectl port-forward -n istio-system $(kubectl get pods -l app=prometheus -n istio-system -o jsonpath="{.items[0].metadata.name}") 9090:9090
