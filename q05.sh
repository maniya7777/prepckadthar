#!/bin/bash

echo "----------------------------------------"
echo "Setting up CKAD Scenario"
echo "----------------------------------------"

# Create namespace
kubectl create namespace garfish

echo "Namespace garfish created"

# Create directory
mkdir -p /ckad/credible-mite

echo "Directory created: /ckad/credible-mite"

# Create deployment YAML
cat <<EOF > /ckad/credible-mite/www.yaml
apiVersion: apps
kind: Deployment
metadata:
  name: www-deployment
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.16
        ports:
        - containerPort: 80
EOF

echo "Deployment YAML created at /ckad/credible-mite/www.yaml"

echo "----------------------------------------"
echo "Environment Ready"
echo "----------------------------------------"
