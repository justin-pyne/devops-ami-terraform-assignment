# ============================================================
# Required — update these values before running terraform apply
# ============================================================

# AMI ID output by Packer (e.g. "ami-0abc1234567890def")
ami_id = "ami-REPLACE_ME"

# Name of your existing EC2 key pair (without the .pem extension)
key_name = "your-key-pair-name"

# ============================================================
# Optional overrides (defaults are set in variables.tf)
# ============================================================

aws_region   = "us-east-1"
project_name = "devops-ami"
instance_type = "t3.micro"

vpc_cidr            = "10.0.0.0/16"
public_subnet_cidr  = "10.0.1.0/24"
private_subnet_cidr = "10.0.2.0/24"

# Restrict this to your public IP for better security, e.g. "203.0.113.5/32"
allowed_ssh_cidr = "0.0.0.0/0"
