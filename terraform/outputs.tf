output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "bastion_public_dns" {
  value = aws_instance.bastion.public_dns
}

output "controller_public_ip" {
  value = aws_instance.ansible_controller.public_ip
}

output "controller_public_dns" {
  value = aws_instance.ansible_controller.public_dns
}

output "amazon_private_ips" {
  value = aws_instance.amazon_instances[*].private_ip
}

output "ubuntu_private_ips" {
  value = aws_instance.ubuntu_instances[*].private_ip
}

output "vpc_id" {
  value = module.vpc.vpc_id
}