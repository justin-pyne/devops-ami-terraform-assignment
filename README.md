# DevOps Assignment - Packer + Terraform + Ansible

## What I Built

### Part A - Custom AMI with Packer
I created a custom Amazon Linux AMI using Packer. The AMI includes Docker and my SSH public key.

### Part B - Infrastructure with Terraform
Using Terraform, I provisioned:
- 1 VPC
- Public and private subnets
- 1 ansible controller in the public subnet
- Static inventory
- 1 playbook
- 1 bastion host in the public subnet
- 1 NAT Gateway
- 6 EC2 instances in the private subnets: 3 Amazon Linux and 3 Ubuntu
- Security groups so that:
  - the bastion + ansible controller only accepts SSH from my IP
  - the private instances only accept SSH from the bastion + ansible


### Part C - Playbook with Ansible
Using Ansible, I created an Ansible Playbook that will:
- Update and upgrade the packages (if needed)
- Verify we are running the latest Docker
- Report the disk usage for each EC2 instance

---

## Files in This Project

- `ansible/` - Ansible files used to configure and run the playbook
- `packer/` - Packer files used to build the custom AMI
- `terraform/` - Terraform files used to provision the infrastructure
- `README.md` - This file
- `screenshots/` - Screenshots showing the completed assignment

---

## How I Ran the Project

### 1. Build the AMI with Packer
From the `packer` directory:

```bash
packer init .
packer validate -var "ssh_public_key_path=$HOME/.ssh/devops-assignment-key.pub" .
packer build -var "ssh_public_key_path=$HOME/.ssh/devops-assignment-key.pub" .
```

This created a custom AMI in AWS.

Make sure to update `terraform.tfvars` with your AMI ID and IP.

### 2. Provision infrastructure with Terraform
From the `terraform` directory:

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

This created the VPC, subnets, bastion host, ansible controller, and 6 private instances.

Take the outputs from terraform and update `inventory.ini` in the `ansible` directory.

### 3. Set up the Ansible Controller
- Add private key to SSH agent forwarding
- SSH to controller with agent forwarding
- install ansible-core
- clone/copy repo



### 4. Run the Ansible Playbook
From the `ansible` directory in the Ansible Controller, run:

```bash
ansible managed -m ping
ansible-playbook playbook.yml --check
ansible-playbook playbook.yml
```

---

## How to Connect

### Connect to the bastion host
```bash
ssh -i ~/.ssh/devops-assignment-key ec2-user@<bastion-public-ip>
```

### Connect from bastion to a private instance
I used SSH agent forwarding:

```bash
ssh-add ~/.ssh/devops-assignment-key
ssh -A -i ~/.ssh/devops-assignment-key ec2-user@<bastion-public-ip>
ssh ec2-user@<private-instance-ip>
```

This allowed me to connect to a private instance through the bastion host.

---

## What to Expect

After running the project:
- The custom AMI appears in EC2 > AMIs
- 1 bastion host + 1 ansible controller are created in the public subnet
- 6 EC2 instances are created in private subnets
- Only the bastion + ansible controller have public IPs
- The private instances are reachable only through the bastion

---

## Screenshots

### Terraform Apply
![Terraform Apply](screenshots/terraform-apply.png)

### EC2 Instances in Console
![EC2 Instances in Console](screenshots/ec2-console.png)

### Ansible Ping Output
![Ansible Ping Output](screenshots/ansible-ping.png)

### Ansible Playbook
![Ansible Playbook](screenshots/ansible-playbook.png)

### Ansible Playbook Output
![Ansible Playbook Output](screenshots/playbook-output.png)

---

## Cleanup

To remove the resources:

```bash
terraform destroy
```
