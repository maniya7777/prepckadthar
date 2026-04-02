#!/bin/bash

echo "----------------------------------------"
echo "Creating CKAD RBAC Troubleshooting Scenario"
echo "----------------------------------------"

echo ""
echo "Question:"
echo "1. View the logs to identify the error message."
echo "   The error will include:"
echo "   User \"system:serviceaccount:gorilla:default\" cannot list resource \"serviceaccounts\" in namespace \"gorilla\"."
echo ""
echo "2. Update the Deployment honeybee-deployment to resolve the error in the Pod logs."
echo "   The manifest file is located at:"
echo "   /ckad/prompt-escargot/honeybee-deployment.yaml"
echo ""

# Create namespace
kubectl create namespace gorilla 2>/dev/null

# Create service accounts
kubectl -n gorilla create serviceaccount gorilla-sa 2>/dev/null
kubectl -n gorilla create serviceaccount boxweb-sa 2>/dev/null

# Create roles
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: gorilla-role
  namespace: gorilla
rules:
- apiGroups: [""]
  resources: ["pods","serviceaccounts"]
  verbs: ["get","list"]
- apiGroups: ["apps"]
  resources: ["deployments"]
  verbs: ["get","list"]
EOF

cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: boxweb-role
  namespace: gorilla
rules:
- apiGroups: [""]
  resources: ["pods","serviceaccounts"]
  verbs: ["watch"]
- apiGroups: ["apps"]
  resources: ["deployments"]
  verbs: ["watch"]
EOF

# Create rolebindings
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: gorilla-rolebinding
  namespace: gorilla
subjects:
- kind: ServiceAccount
  name: gorilla-sa
  namespace: gorilla
roleRef:
  kind: Role
  name: gorilla-role
  apiGroup: rbac.authorization.k8s.io
EOF

cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: boxweb-rolebinding
  namespace: gorilla
subjects:
- kind: ServiceAccount
  name: boxweb-sa
  namespace: gorilla
roleRef:
  kind: Role
  name: boxweb-role
  apiGroup: rbac.authorization.k8s.io
EOF

# Create directory for question manifest
mkdir -p /ckad/prompt-escargot

# Create deployment manifest with WRONG service account (default)
cat <<EOF > /ckad/prompt-escargot/honeybee-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: honeybee-deployment
  namespace: gorilla
spec:
  replicas: 1
  selector:
    matchLabels:
      app: honeybee
  template:
    metadata:
      labels:
        app: honeybee
    spec:
      serviceAccountName: default
      containers:
      - name: honeybee
        image: bitnami/kubectl
        command: ["/bin/sh","-c"]
        args:
        - |
          while true; do
            date
            kubectl get serviceaccounts -n gorilla
            sleep 10
          done
EOF

# Apply deployment
kubectl apply -f /ckad/prompt-escargot/honeybee-deployment.yaml

echo ""
echo "----------------------------------------"
echo "Environment Ready"
echo "----------------------------------------"
echo ""
echo "Useful commands:"
echo "kubectl -n gorilla get pods"
echo "kubectl -n gorilla logs <pod-name>"
echo ""
echo "Candidate must update the deployment to use:"
echo "serviceAccountName: gorilla-sa"
echo ""
