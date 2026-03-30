variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Prefix applied to all resource names and tags"
  type        = string
  default     = "devops-ami"
}

variable "ami_id" {
  description = "ID of the custom AMI built by Packer (Amazon Linux 2 + Docker)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for both bastion and private instances"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of an existing EC2 key pair to use for SSH access"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet (bastion host)"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet (private instance)"
  type        = string
  default     = "10.0.2.0/24"
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into the bastion host (e.g. your public IP)"
  type        = string
  default     = "0.0.0.0/0" # Restrict this to your IP in production!
}
