#!/bin/bash

echo "---------------------------------------------------------"
echo "CKAD Troubleshooting Scenario - Ingress Issue"
echo "---------------------------------------------------------"
echo ""
echo "QUESTION:"
echo "In the namespace ingress-ckad, the Deployment nginx-dm is exposed via the Ingress nginx-ingress-test.The manifest files for the Deployment, Service, and Ingress can be found in the directory /ckad/CKAD202206/.The Deployment should be accessible, but it currently returns an error.Identify and fix the issue by updating relevant resources so the Deployment can be accessed as intended.Note: The Deployment is correct; do NOT modify it. Assume the Deployment is functional.Finaly, test access using the command curl -L http://ckad-ingress-test.local."
echo "Service name should be nginx-ing-svc"
echo ""
echo "---------------------------------------------------------"
echo "Setting up environment..."
echo "---------------------------------------------------------"

mkdir -p /ckad/CKAD202206

kubectl create namespace ingress-ckad 2>/dev/null

echo "Creating Deployment manifest"

cat <<EOF > /ckad/CKAD202206/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-dm
  namespace: ingress-ckad
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-ing
  template:
    metadata:
      labels:
        app: nginx-ing
    spec:
      containers:
      - name: nginx
        image: vicuw/nginx:hello
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
        startupProbe:
          httpGet:
            path: /
            port: 80
          failureThreshold: 30
          periodSeconds: 10
EOF

echo "Creating Service manifest (contains issue)"

cat <<EOF > /ckad/CKAD202206/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  namespace: ingress-ckad
spec:
  selector:
    app: nginx001
  ports:
  - port: 89
    targetPort: 89
EOF

echo "Creating Ingress manifest"

cat <<EOF > /ckad/CKAD202206/ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx-ingress-test
  namespace: ingress-ckad
spec:
  rules:
  - host: ckad-ingress-test.local
    http:
      paths:
      - path: /display
        pathType: Prefix
        backend:
          service:
            name: nginx-service-01
            port:
              number: 89
EOF

echo "Applying manifests"

kubectl apply -f /ckad/CKAD202206/deployment.yaml

echo ""
echo "Test after fixing:"
echo "curl -L http://ckad-ingress-test.local"
