#!/bin/bash

echo "----------------------------------------"
echo "KillerCoda CKAD Lab Setup Script"
echo "----------------------------------------"

# Print the question
echo ""
echo "CKAD Question:"
echo "A web application is running in the namespace 'external', and the Service 'web-app' makes the application accessible within the cluster on port 8080."
echo "Create an Ingress resource named 'web-app-ingress' to expose the application externally using the URL 'external.sterling-bengal.local'."
echo "All requests starting with / must be routed to the 'web-app' application."
echo "Finally, test access using the command:"
echo "curl -L external.sterling-bengal.local"
echo "Use Traefik ingressClass for this task."
echo ""

# 1️⃣ Install Traefik ingress controller if not already installed
kubectl get ns traefik >/dev/null 2>&1 || \
kubectl create ns traefik

echo "Installing Traefik ingress controller..."
# Add Traefik repo
helm repo add traefik https://traefik.github.io/charts
helm repo update

# Install Traefik in namespace 'traefik'
kubectl create ns traefik 2>/dev/null
helm install traefik traefik/traefik --namespace traefik

echo "Traefik ingress installed."

# 2️⃣ Create namespace
kubectl create namespace external 2>/dev/null && echo "Namespace 'external' created" || echo "Namespace 'external' already exists"

# 3️⃣ Create deployment
mkdir -p /ckad/external

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
        image: nginx:1.16
        ports:
        - containerPort: 8080
EOF

kubectl apply -f /ckad/external/web-app-deployment.yaml

# 4️⃣ Create service
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
echo "You can test access using:"
echo "curl -L external.sterling-bengal.local"
echo "----------------------------------------"
