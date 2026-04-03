#!/bin/bash

# Create manifest directory

mkdir -p /ckad/goshawk

# Print the question exactly

cat <<'EOF'

The Service chipmunk-service in the namespace goshawk points to 5 Pods created by the Deployment current-chipmunk-deployment. The
manifest file for current-chipmunk-deployment can be found in /ckad/goshawk/.
Create an identical Deployment in the same namespace, named canary-chipmunk-deployment.
Modify the Deployments so: The maximum number of Pods running in the namespace goshawk is 10.
40% of traffic to chipmunk-service is routed to the Pods of canary-chipmunk-deployment.

EOF

# Create namespace

kubectl create namespace goshawk

# Create deployment manifest

cat <<EOF > /ckad/goshawk/current-chipmunk-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
name: current-chipmunk-deployment
namespace: goshawk
spec:
replicas: 5
selector:
matchLabels:
app: chipmunk
version: current
template:
metadata:
labels:
app: chipmunk
version: current
spec:
containers:
- name: chipmunk
image: hashicorp/http-echo
args:
- "-text=hello-world"
- "-listen=:5678"
ports:
- containerPort: 5678
EOF

# Apply deployment

kubectl apply -f /ckad/goshawk/current-chipmunk-deployment.yaml

# Create NodePort service

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
name: chipmunk-service
namespace: goshawk
spec:
type: NodePort
selector:
app: chipmunk
ports:

* port: 80
  targetPort: 5678
  nodePort: 30007
  EOF

echo ""
echo "Environment setup completed."
echo "Deployment manifest location: /ckad/goshawk/current-chipmunk-deployment.yaml"
echo ""
echo "Test service:"
echo "curl <NODE-IP>:30007"
echo "Expected output: hello-world"
