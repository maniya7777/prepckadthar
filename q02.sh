#!/bin/bash

clear

echo "========================================"
echo " Kubernetes Practice Environment"
echo "========================================"
echo ""

echo "QUESTION:"
echo ""
echo "Create a CronJob named ppi that runs a Pod with a single container:"
echo ""
echo "Container name: pi"
echo "Image: perl:5"
echo 'Command: ["perl", "-Mbignum=bpi", "-wle", "print bpi(2000)"]'
echo ""
echo "Configure the CronJob with:"
echo ""
echo "- Run every 5 minutes"
echo "- Retain 2 completed Jobs"
echo "- Retain 4 failed Jobs"
echo "- Never restart the Pod"
echo "- Terminate the Pod after 8 seconds"
echo ""
echo "For testing purposes:"
echo "Manually create and run a Job named ppi-test from the CronJob ppi."
echo "(Job success or failure does not matter.)"
echo ""
echo "========================================"
echo " Environment Ready"
echo "========================================"
echo ""

echo "Start solving the question."