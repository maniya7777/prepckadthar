#!/bin/bash

echo "----------------------------------------------------"
echo "Setting up CKAD NetworkPolicy Troubleshooting Lab"
echo "----------------------------------------------------"

# Create namespace
kubectl create namespace ckad00018 2>/dev/null

# -------------------------
# Create Pods
# -------------------------

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: ckad00018-newpod
  namespace: ckad00018
  labels:
    app: ckad00018-newpod
    item: CKAD00018
spec:
  containers:
  - name: nginx
    image: nginx
EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: front
  namespace: ckad00018
  labels:
    app: front
    item: CKAD00018
spec:
  containers:
  - name: nginx
    image: nginx
EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: db
  namespace: ckad00018
  labels:
    app: db
    item: CKAD00018
spec:
  containers:
  - name: nginx
    image: nginx
EOF


# -------------------------
# NetworkPolicy: default-deny
# -------------------------

cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny
  namespace: ckad00018
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
EOF


# -------------------------
# NetworkPolicy: access-front
# -------------------------

cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: access-front
  namespace: ckad00018
spec:
  podSelector:
    matchLabels:
      app: front
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          front-access: "true"
  egress:
  - to:
    - podSelector:
        matchLabels:
          front-access: "true"
EOF


# -------------------------
# NetworkPolicy: access-db
# -------------------------

cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: access-db
  namespace: ckad00018
spec:
  podSelector:
    matchLabels:
      app: db
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          db-access: "true"
  egress:
  - to:
    - podSelector:
        matchLabels:
          db-access: "true"
EOF


# -------------------------
# NetworkPolicy: all-access
# -------------------------

cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: all-access
  namespace: ckad00018
spec:
  podSelector:
    matchLabels:
      all-access: "true"
  ingress:
  - {}
  egress:
  - {}
  policyTypes:
  - Ingress
  - Egress
EOF


echo ""
echo "Environment Setup Complete"
echo ""

# -------------------------
# Print Question
# -------------------------

echo "----------------------------------------------------"
echo "QUESTION"
echo "----------------------------------------------------"
echo ""
echo "Update the Pod ckad00018-newpod in the namespace ckad00018 to use a NetworkPolicy that only alows traffic between this Pod and the Pods front and db."
echo "All necessary NetworkPolicies have already been created."
echo "Do NOT create, modify, or delete any NetworkPolicies during this task - only use existing ones."
echo ""
