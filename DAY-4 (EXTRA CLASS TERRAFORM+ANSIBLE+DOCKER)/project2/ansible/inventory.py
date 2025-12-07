#!/usr/bin/env python3
import boto3
import json

ec2 = boto3.client("ec2", region_name="us-east-1")

response = ec2.describe_instances()

inventory = {
    "all": {
        "hosts": []
    },
    "_meta": {
        "hostvars": {}
    }
}


for reservation in response["Reservations"]:
    for instance in reservation["Instances"]:
        if instance["State"]["Name"] == "running":
            public_ip = instance.get("PublicIpAddress")
            if not public_ip:
                continue

            hostname = f"ec2-{public_ip.replace('.', '-')}.compute-1.amazonaws.com"

            inventory["all"]["hosts"].append(hostname)

            inventory["_meta"]["hostvars"][hostname] = {
                "ansible_host": public_ip,
                "ansible_user": "ubuntu",
                "ansible_ssh_private_key_file": "../terraform/ec2-key.pem"
            }

print(json.dumps(inventory))
