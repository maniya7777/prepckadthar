#!/bin/bash

echo "----------------------------------------------------"
echo "CKAD Practice Question"
echo "----------------------------------------------------"
echo ""
echo "First, create a new Secret named postgres in the namespace relaxed-shark. It must contain the three secret values currently hardcoded in the environment variables of the Pods from the Deployment postgres running in the namespace relaxed-shark. Use the following keys username, database, and password."
echo ""
echo "Next, modify the Deployment to use the new Secret. Set the environment variables so their values are taken from the username, database and password keys of the new Secret. Do not delete the existing Deployment, as this will result in a lower score."
echo ""
echo "----------------------------------------------------"
echo "Setting up the lab environment..."
echo "----------------------------------------------------"

# Create namespace
kubectl create namespace relaxed-shark

echo "Namespace relaxed-shark created"

# Create Deployment with hardcoded env variables
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres
  namespace: relaxed-shark
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
      - name: postgres
        image: postgres:13
        env:
        - name: POSTGRES_USER
          value: tux
        - name: POSTGRES_DB
          value: kubestronauts
        - name: POSTGRES_PASSWORD
          value: Kubernetes123
EOF

echo "Deployment postgres created with hardcoded environment variables."

echo ""
echo "----------------------------------------------------"
echo "Lab environment is ready!"
echo "----------------------------------------------------"
