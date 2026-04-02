#!/bin/bash

echo "----------------------------------------"
echo "Creating Resource Management Scenario"
echo "----------------------------------------"

# Create namespace
kubectl create namespace pod-resources

echo "Namespace pod-resources created"

# Create ResourceQuota
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ResourceQuota
metadata:
  name: pod-resources-quota
  namespace: pod-resources
spec:
  hard:
    limits.cpu: "26m"
    limits.memory: "26Mi"
EOF

echo "ResourceQuota created"

# Create Deployment WITHOUT resources (candidate must fix)
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-resources
  namespace: pod-resources
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-resources
  template:
    metadata:
      labels:
        app: nginx-resources
    spec:
      containers:
      - name: nginx
        image: nginx
EOF

echo "Deployment nginx-resources created"

echo ""
echo "----------------------------------------"
echo "SCENARIO"
echo "----------------------------------------"
echo ""
echo "Modify the Pods of the Deployment in the namespace pod-resources to:"
echo ""
echo "Request 20m CPU and 26Mi memory."
echo "Set CPU and memory limits to twice their respective requests."
echo "Ensure the maximum total resources available to the Pods of Deployment nginx-resources match the total resources in the namespace."
echo ""
echo "----------------------------------------"
echo ""
echo "Check the namespace:"
echo "kubectl describe ns pod-resources"
echo ""