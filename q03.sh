#!/bin/bash

clear

echo "========================================"
echo "Kubernetes CKAD Practice Question"
echo "========================================"
echo ""

cat <<EOF
Task

First, update the Deployment ckad00017-deployment in the namespace ckad00017: Scale it to run 3 Pod replicas and add the label tier: dmz to the Pods. 
Then, create a NodePort Service named rover in the namespace ckad00017 to expose the Deployment ckad00017-deployment on TCP port 81. 
When accessing NodeIP:NodePort the output should display 'Hello World'.

EOF

echo "========================================"
echo "Preparing Environment..."
echo "========================================"

# create namespace
kubectl create namespace ckad00017

# create initial deployment
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ckad00017-deployment
  namespace: ckad00017
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ckad00017
  template:
    metadata:
      labels:
        app: ckad00017
    spec:
      containers:
      - name: web
        image: busybox
        command: ["/bin/sh","-c"]
        args:
        - while true; do echo -e "HTTP/1.1 200 OK\n\nHello World" | nc -l -p 81; done
        ports:
        - containerPort: 81
EOF

echo ""
echo "Environment ready."
echo ""
echo "Check resources with:"
echo "kubectl get all -n ckad00017"
echo ""
echo "Now solve the task."
