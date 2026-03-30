output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private.id
}

output "bastion_public_ip" {
  description = "Public IP address of the bastion host"
  value       = aws_instance.bastion.public_ip
}

output "bastion_instance_id" {
  description = "Instance ID of the bastion host"
  value       = aws_instance.bastion.id
}

output "private_instance_ip" {
  description = "Private IP address of the private instance"
  value       = aws_instance.private.private_ip
}

output "private_instance_id" {
  description = "Instance ID of the private instance"
  value       = aws_instance.private.id
}

output "ssh_bastion_command" {
  description = "Command to SSH into the bastion host"
  value       = "ssh -i ~/.ssh/${var.key_name}.pem ec2-user@${aws_instance.bastion.public_ip}"
}

output "ssh_private_via_bastion_command" {
  description = "Command to SSH into the private instance via the bastion (ProxyJump)"
  value       = "ssh -i ~/.ssh/${var.key_name}.pem -J ec2-user@${aws_instance.bastion.public_ip} ec2-user@${aws_instance.private.private_ip}"
}
