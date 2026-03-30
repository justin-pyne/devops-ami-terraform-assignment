packer {
  required_plugins {
    amazon = {
      version = ">= 1.3.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

# ---------------------------------------------------------------------------
# Variables
# ---------------------------------------------------------------------------

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ami_name_prefix" {
  type    = string
  default = "amazon-linux-docker"
}

# ---------------------------------------------------------------------------
# Data source — find the latest Amazon Linux 2 AMI
# ---------------------------------------------------------------------------

data "amazon-ami" "amazon_linux_2" {
  region = var.aws_region
  filters = {
    name                = "amzn2-ami-hvm-*-x86_64-gp2"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["amazon"]
}

# ---------------------------------------------------------------------------
# Source block
# ---------------------------------------------------------------------------

source "amazon-ebs" "amazon_linux_docker" {
  region        = var.aws_region
  instance_type = var.instance_type
  source_ami    = data.amazon-ami.amazon_linux_2.id

  ssh_username = "ec2-user"

  ami_name        = "${var.ami_name_prefix}-${formatdate("YYYYMMDD-hhmmss", timestamp())}"
  ami_description = "Amazon Linux 2 with Docker CE pre-installed"

  tags = {
    Name        = "amazon-linux-docker"
    OS          = "Amazon Linux 2"
    Docker      = "true"
    BuildDate   = formatdate("YYYY-MM-DD", timestamp())
    ManagedBy   = "Packer"
  }

  launch_block_device_mappings {
    device_name           = "/dev/xvda"
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
  }
}

# ---------------------------------------------------------------------------
# Build block
# ---------------------------------------------------------------------------

build {
  name    = "amazon-linux-docker"
  sources = ["source.amazon-ebs.amazon_linux_docker"]

  # Copy the setup script to the instance
  provisioner "file" {
    source      = "setup.sh"
    destination = "/tmp/setup.sh"
  }

  # Run the setup script
  provisioner "shell" {
    inline = [
      "chmod +x /tmp/setup.sh",
      "sudo /tmp/setup.sh",
    ]
  }

  # Verify Docker is installed and running
  provisioner "shell" {
    inline = [
      "echo '=== Docker version ==='",
      "docker --version",
      "echo '=== Docker service status ==='",
      "sudo systemctl is-active docker",
    ]
  }
}
