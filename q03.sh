#!/bin/bash

clear

echo "========================================"
echo "Kubernetes CKAD Practice Question"
echo "========================================"
echo ""

echo "Task"
echo ""
echo "First, update the Deployment ckad00017-deployment in the namespace ckad00017: Scale it to run 3 Pod replicas. Add the label tier: dmz to the Pods."
echo ""
echo "Then, create a NodePort Service named rover in the namespace ckad00017 to expose the Deployment ckad00017-deployment on TCP port 81."
echo ""

echo "========================================"
echo "Preparing Environment..."
echo "========================================"

# create namespace
kubectl create namespace ckad00017

# create initial deployment (not matching required state)
kubectl create deployment ckad00017-deployment \
  --image=nginx \
  --replicas=1 \
  -n ckad00017

echo ""
echo "Environment ready."
echo ""
echo "Check resources with:"
echo "kubectl get all -n ckad00017"
echo ""
echo "Now solve the task."