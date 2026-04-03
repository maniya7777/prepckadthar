#!/bin/bash

# Create manifest directory
mkdir -p /ckad

# Print the question exactly
cat <<'EOF'

Create a Secret named another-secret in the namespace default that contains the following single key-value pair: key1: value2.
Create a Pod named nginx-secret in the namespace default. Specify a container using the nginx:1.16 image. Add an environment variable 
named COOL_VARIABLE that uses the value of the key1 key from the Secret.

EOF

echo ""
echo "Environment setup completed."
