terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.23.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  access_key = ""
  secret_key = ""
  
}

# Generate an SSH key pair automatically
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Save private key in local directory
resource "local_file" "private_key" {
  content         = tls_private_key.key.private_key_pem
  filename        = "${path.module}/ec2-key.pem"
  file_permission = "0400"
}

# Create AWS key pair
resource "aws_key_pair" "generated_key" {
  key_name   = "tf-lab-key"
  public_key = tls_private_key.key.public_key_openssh
}

# Security group
resource "aws_security_group" "allow_ssh_new" {
  name = "allow_ssh_lab_new"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch EC2 instance
resource "aws_instance" "vm" {
  ami                         = "ami-0ecb62995f68bb549" # Ubuntu 22.04 (us-east-1)
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.generated_key.key_name
  vpc_security_group_ids      = [aws_security_group.allow_ssh_new.id]

  tags = {
    Name = "TerraformAutomationVM"
  }
}
