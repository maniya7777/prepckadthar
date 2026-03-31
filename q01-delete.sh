#!/bin/bash

echo "----------------------------------------"
echo "Cleaning RBAC Troubleshooting Scenario"
echo "----------------------------------------"

# Delete namespace (removes everything inside it)
kubectl delete namespace cute-panda --ignore-not-found=true

echo "Namespace cute-panda deleted"

echo "----------------------------------------"
echo "Cleanup Complete"
echo "----------------------------------------"