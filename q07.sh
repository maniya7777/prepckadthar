#!/bin/bash

clear

echo "----------------------------------------"
echo "Creating Readiness Probe Scenario"
echo "----------------------------------------"

# Create namespace
kubectl create namespace prod27

echo "Namespace prod27 created"

# Create deployment WITHOUT readiness probe
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: probe-http
  namespace: prod27
spec:
  replicas: 1
  selector:
    matchLabels:
      app: probe-http
  template:
    metadata:
      labels:
        app: probe-http
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
EOF

echo "Deployment probe-http created"

echo ""
echo "----------------------------------------"
echo "QUESTION"
echo "----------------------------------------"
echo ""

echo "Deployment named probe-http in the prod27 namespace runs a web application on port 80."
echo "Modify the Deployment to:"
echo ""
echo "Specify a readiness probe with the path /healthz/return200."
echo "Set initialDelaySeconds to 15 (wait 15 seconds before the first probe)."
echo "Set periodSeconds to 20 (probe interval of 20 seconds)."

echo ""
echo "----------------------------------------"
echo ""
echo "Example check command:"
echo "kubectl -n prod27 get deploy probe-http -o yaml"
echo ""