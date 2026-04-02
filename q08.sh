#!/bin/bash

echo "----------------------------------------"
echo "KillerCoda CKAD Lab Setup Script"
echo "----------------------------------------"

# Print the question
echo ""
echo "CKAD Question:"
echo "1. Update the scaling configuration of the Deployment webapp in the namespace ckad00015: set maxSurge to 5% and maxUnavailable to 5%."
echo "2. Update the Deployment webapp to use the container image lfccncf/nginx with the version tag 1.13.7."
echo "3. Roll back the Deployment webapp to the previous version."
echo ""

# Create namespace for the scenario
kubectl create namespace ckad00015 2>/dev/null && echo "Namespace ckad00015 created" || echo "Namespace ckad00015 already exists"

# Create a sample deployment YAML for webapp
mkdir -p /ckad/ckad00015

cat <<EOF > /ckad/ckad00015/webapp-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp
  namespace: ckad00015
spec:
  replicas: 3
  selector:
    matchLabels:
      app: webapp
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
  template:
    metadata:
      labels:
        app: webapp
    spec:
      containers:
      - name: webapp
        image: nginx:1.16
        ports:
        - containerPort: 80
EOF

echo "Deployment YAML created at /ckad/ckad00015/webapp-deployment.yaml"

# Apply the deployment
kubectl apply -f /ckad/ckad00015/webapp-deployment.yaml

echo "----------------------------------------"
echo "Environment is ready. You can now perform:"
echo " - Updating maxSurge and maxUnavailable"
echo " - Updating container image"
echo " - Rolling back Deployment"
echo "----------------------------------------"
