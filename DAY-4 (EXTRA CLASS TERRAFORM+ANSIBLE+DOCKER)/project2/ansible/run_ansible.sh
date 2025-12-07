#!/bin/bash

echo "========================================"
echo " Running Ansible Playbook Automatically"
echo "========================================"

cd $(dirname "$0")


echo "[2] Running Ansible Playbook..."
ansible-playbook -i inventory.py apache.yml

echo "========================================"
echo " Apache installation complete!"
echo "========================================"
