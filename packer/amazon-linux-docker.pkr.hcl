packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.3.0"
    }
  }
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "ssh_public_key_path" {
  type = string
}

locals {
  ssh_public_key = trimspace(file(var.ssh_public_key_path))
  timestamp      = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "amazon_linux_docker" {
  region        = var.aws_region
  instance_type = "t2.micro"
  ssh_username  = "ec2-user"

  ami_name        = "devops-amazon-linux-docker-${local.timestamp}"
  ami_description = "Amazon Linux AMI with Docker and custom SSH public key"

  source_ami_filter {
    filters = {
      name                = "al2023-ami-2023.*-x86_64"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    owners      = ["137112412989"]
    most_recent = true
  }
}

build {
  sources = ["source.amazon-ebs.amazon_linux_docker"]

  provisioner "shell" {
    environment_vars = [
      "SSH_PUBLIC_KEY=${local.ssh_public_key}"
    ]
    script = "setup.sh"
  }
}