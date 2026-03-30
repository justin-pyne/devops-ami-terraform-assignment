output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "bastion_public_dns" {
  value = aws_instance.bastion.public_dns
}

output "private_instance_private_ips" {
  value = aws_instance.private_instances[*].private_ip
}

output "private_instance_ids" {
  value = aws_instance.private_instances[*].id
}

output "vpc_id" {
  value = module.vpc.vpc_id
}