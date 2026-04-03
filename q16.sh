#!/bin/bash

clear

echo "============================================================"
echo "CKAD Deployment Update Question"
echo "============================================================"

cat << 'EOF'

Update the existing Deployment busybox running in the namespace rapid-goat. 
a score of 0.
First, change the container name to musl.
Next, change the container image to busybox:musl.
Finally, ensure the changes to the Deployment busybox running in the namespace rapid-goat are successfully applied.

EOF

echo "============================================================"
echo "Setting up the environment..."
echo "============================================================"

# Create namespace
kubectl create namespace rapid-goat

# Create Deployment YAML
cat <<EOF > /tmp/busybox-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: busybox
  namespace: rapid-goat
spec:
  progressDeadlineSeconds: 600
  paused: true
  replicas: 1
  selector:
    matchLabels:
      app: busybox
  template:
    metadata:
      labels:
        app: busybox
    spec:
      containers:
      - name: myapp
        image: busybox
        imagePullPolicy: IfNotPresent
        command:
        - sh
        - -c
        - while true; do echo 'Container is running...'; sleep 3000; done
EOF

# Apply deployment
kubectl apply -f /tmp/busybox-deployment.yaml

echo ""
echo "Environment setup completed."
echo ""
