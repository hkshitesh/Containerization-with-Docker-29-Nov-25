#!/bin/bash

echo "====================================="
echo " Terraform + Ansible Automation Lab"
echo "====================================="

cd $(dirname "$0")

echo "[1] Initializing Terraform..."
terraform init

echo "[2] Applying Terraform configuration..."
terraform apply -auto-approve

echo "[3] Terraform deployment complete!"
PUBLIC_IP=$(terraform output -raw public_ip)
KEY_FILE=$(terraform output -raw private_key_file)

echo "EC2 Public IP: $PUBLIC_IP"
echo "PEM File: $KEY_FILE"

echo "[4] Running Ansible automation..."
cd ../ansible
./run_ansible.sh

echo "====================================="
echo " Lab Completed Successfully!"
echo "====================================="
