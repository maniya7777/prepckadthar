#!/bin/bash

clear

echo "============================================================"
echo "CKAD Troubleshooting Question"
echo "============================================================"

cat << 'EOF'

Pods of the Deployment nosql in the namespace haddock fail to start because their containers have exhausted resources. Update the nosql 
Deployment so the Pods:
Request 15Mi of memory for their containers.
Set the memory limit to half of the maximum memory capacity configured for the haddock namespace.
The configuration manifest for the nosql Deployment can be found at /ckad/chief-cardinal/nosql.yaml.

EOF

echo "============================================================"
echo "Setting up the environment..."
echo "============================================================"

# Create namespace
kubectl create namespace haddock

# Create LimitRange to simulate namespace memory constraints
cat <<EOF | kubectl apply -n haddock -f -
apiVersion: v1
kind: LimitRange
metadata:
  name: haddock-memory-limit
spec:
  limits:
  - type: Container
    max:
      memory: 40Mi
    default:
      memory: 16Mi
    defaultRequest:
      memory: 8Mi
EOF

# Create directory for manifest
mkdir -p /ckad/chief-cardinal

# Create faulty Deployment manifest
cat <<EOF > /ckad/chief-cardinal/nosql.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nosql
  namespace: haddock
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nosql
  template:
    metadata:
      labels:
        app: nosql
    spec:
      containers:
      - name: nginx
        image: nginx:1.16
        resources:
          requests:
            memory: "90Mi"
          limits:
            memory: "120Mi"
EOF

# Apply deployment
kubectl apply -f /ckad/chief-cardinal/nosql.yaml

echo
echo "Environment setup completed."
echo ""
