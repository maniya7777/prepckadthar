#!/bin/bash

clear

echo "========================================"
echo "CKAD Practice Environment"
echo "========================================"
echo ""

echo "Modify the existing Deployment broker-deployment running in the namespace quetzal so that its container:"
echo ""
echo "Runs as user 30000."
echo "Disables privilege escalation."
echo "Adds the NET_BIND_SERVICE capability."
echo ""
echo "The manifest file for broker-deployment can be found at /ckad/daring-moccasin/broker-deployment.yaml."
echo ""

echo "========================================"
echo "Preparing Environment..."
echo "========================================"

# create namespace

kubectl create namespace quetzal

# create directory for manifest

mkdir -p /ckad/daring-moccasin

# create deployment yaml (file only)

cat <<EOF > /ckad/daring-moccasin/broker-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: broker-deployment
  namespace: quetzal
spec:
  replicas: 1
  selector:
    matchLabels:
      app: broker
  template:
    metadata:
      labels:
        app: broker
    spec:
      containers:
      - name: broker
        image: nginx
        ports:
        - containerPort: 80
EOF

echo ""
echo "Environment Ready!"
echo ""
echo "Manifest location:"
echo "/ckad/daring-moccasin/broker-deployment.yaml"
echo ""
echo "The deployment has NOT been created in the cluster."
echo "Use the manifest file above to modify and apply it."
