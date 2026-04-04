#!/bin/bash

echo "----------------------------------------"
echo "Creating Container Image Build Scenario"
echo "----------------------------------------"

echo ""
echo "A Dockerfile exists at /ckad/DF/Dockerfile."
echo "Use this Dockerfile to build a container image named 'centos' with the tag '8.2'."
echo ""
echo "You can install and use any tool of your choice."
echo "The system has pre-installed OCI-compliant image builders/tools: docker, skopeo, buildah, img, podman "
echo ""
echo "Do NOT push the built image to a registry, run the container or use the image in any other way."
echo ""
echo "Export the built container image in OCI format and store it at:"/ckad/DF/centos-8.2.tar""
echo ""

# Create directory structure
mkdir -p /ckad/DF

# Create Dockerfile
cat <<EOF > /ckad/DF/Dockerfile
FROM centos:8
LABEL maintainer="ckad-lab"
CMD ["/bin/bash"]
EOF

echo "Dockerfile created at /ckad/DF/Dockerfile"

echo ""
echo "----------------------------------------"
echo "Environment Ready"
echo "----------------------------------------"
