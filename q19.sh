#!/bin/bash

# Create manifest directory
mkdir -p /ckad/ckad00014

# Print the question exactly
cat <<'EOF'

Create a Deployment named api in the existing namespace ckad00014 that runs 6 Pod replicas. Specify a container using the nginx:1.16 
image. Add an environment variable named NGINX_PORT with a value of 8000 to the container, then expose port 80.

EOF

echo ""
echo "Environment setup completed."
echo ""
