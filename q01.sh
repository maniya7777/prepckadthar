#!/bin/bash

echo "----------------------------------------"
echo "Creating RBAC Troubleshooting Scenario"
echo "----------------------------------------"

# Create namespace
kubectl create namespace cute-panda

echo "Namespace created"

# Create Role: event-reader
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: event-reader
  namespace: cute-panda
rules:
- apiGroups: [""]
  resources: ["events"]
  verbs: ["get","list"]
EOF

echo "Role event-reader created"

# Create Role: pod-list (THIS IS THE CORRECT ROLE FOR THE TASK)
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-list
  namespace: cute-panda
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get","list"]
EOF

echo "Role pod-list created"

# Create Role: pod-logs
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-logs
  namespace: cute-panda
rules:
- apiGroups: [""]
  resources: ["pods/log"]
  verbs: ["get"]
EOF

echo "Role pod-logs created"

# Create Deployment using default ServiceAccount
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: scraper
  namespace: cute-panda
spec:
  replicas: 1
  selector:
    matchLabels:
      app: scraper
  template:
    metadata:
      labels:
        app: scraper
    spec:
      containers:
      - name: scraper
        image: bitnami/kubectl:latest
        command: ["/bin/sh","-c"]
        args:
        - |
          echo "Starting scraper..."
          while true; do
            kubectl get pods -n cute-panda
            sleep 10
          done
EOF

echo "Deployment created"

sleep 5

echo ""
echo "----------------------------------------"
echo "Scenario Ready"
echo "----------------------------------------"
echo ""
echo "Student Tasks:"
echo ""
echo "1. First, identify the RBAC permissions required by the Deployment scraper running in the namespace cute-panda. (Hint: Use kubectl logs to find the required permissions.)"
echo "2. Create a new ServiceAccount named scraper in the namespace cute-panda."
echo "3. Check the existing Roles in the namespace cute-panda and bind the most appropriate Role to the new ServiceAccount scraper."
echo "4. Update the Deployment scraper to use the new ServiceAccount scraper"
echo ""
echo ""
echo "----------------------------------------"