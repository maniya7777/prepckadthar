#!/bin/bash

echo "----------------------------------------"
echo "KillerCoda CKAD Lab Setup Script"
echo "----------------------------------------"

# Print the question
cat <<EOF

CKAD Question:
A web application is running in the namespace 'external', and the Service 'web-app' makes the application accessible within the cluster on port 8080. Create an Ingress resource named 'web-app-ingress' to expose the application externally using the URL 'external.sterling-bengal.local'. All requests starting with / must be routed to the 'web-app' application. Finally, test access using the command: curl -L external.sterling-bengal.local. Use Traefik ingressClass for this task.

EOF

# Install Traefik ingress controller if not already installed
kubectl get ns traefik >/dev/null 2>&1 || kubectl create ns traefik

echo "Installing Traefik ingress controller..."

helm repo add traefik https://traefik.github.io/charts >/dev/null 2>&1
helm repo update >/dev/null 2>&1

helm install traefik traefik/traefik --namespace traefik 2>/dev/null || echo "Traefik already installed"

echo "Traefik ingress installed."

# Create namespace
kubectl create namespace external 2>/dev/null && echo "Namespace 'external' created" || echo "Namespace 'external' already exists"

# Create directory
mkdir -p /ckad/external

# Create deployment (serves Hello World on port 8080)
cat <<EOF > /ckad/external/web-app-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  namespace: external
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
      - name: web-app
        image: busybox
        command: ["/bin/sh","-c"]
        args:
        - while true; do echo -e "HTTP/1.1 200 OK\n\nHello World" | nc -l -p 8080; done
        ports:
        - containerPort: 8080
EOF

kubectl apply -f /ckad/external/web-app-deployment.yaml

# Create service
cat <<EOF > /ckad/external/web-app-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: web-app
  namespace: external
spec:
  selector:
    app: web-app
  ports:
  - protocol: TCP
    port: 8080
    targetPort: 8080
EOF

kubectl apply -f /ckad/external/web-app-service.yaml

echo "----------------------------------------"
echo "Environment setup complete!"
echo ""
echo "Once the correct Ingress is created, the following should return:"
echo "Hello World"
echo ""
echo "Test with:"
echo "curl -L external.sterling-bengal.local"
echo "----------------------------------------"
