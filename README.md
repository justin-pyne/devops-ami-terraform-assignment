# DevOps AMI & Terraform Assignment

This project demonstrates building a custom Amazon Linux 2 AMI with Docker pre-installed using **Packer**, then deploying a VPC architecture with bastion and private EC2 instances using **Terraform**.

## Architecture Overview

```
Internet
    │
    ▼
[ Internet Gateway ]
    │
[ Public Subnet ]  ──►  Bastion Host (EC2)
    │
[ Private Subnet ] ──►  Private Instance (EC2)
```

- **VPC** with public and private subnets across one availability zone
- **Bastion host** in the public subnet — SSH entry point
- **Private instance** in the private subnet — accessible only via bastion
- **Custom AMI** (Amazon Linux 2 + Docker) used for both instances

## Prerequisites

| Tool      | Version  |
|-----------|----------|
| Packer    | >= 1.9   |
| Terraform | >= 1.5   |
| AWS CLI   | >= 2.0   |

AWS credentials must be configured (e.g. via `aws configure` or environment variables).

---

## Part 1 — Build the AMI with Packer

```bash
cd packer/
packer init .
packer build amazon-linux-docker.pkr.hcl
```

On success, note the **AMI ID** printed at the end (e.g. `ami-0abc123...`).

**Screenshot:** `screenshots/01-packer-build-success.png`, `screenshots/02-ami-created.png`

---

## Part 2 — Deploy Infrastructure with Terraform

1. Copy the AMI ID into `terraform/terraform.tfvars`:
   ```hcl
   ami_id = "ami-0abc123..."
   ```

2. Apply:
   ```bash
   cd terraform/
   terraform init
   terraform plan
   terraform apply
   ```

**Screenshot:** `screenshots/03-terraform-apply-success.png`, `screenshots/04-ec2-instances.png`, `screenshots/05-vpc-subnets.png`

---

## Part 3 — SSH Access

### Connect to the Bastion

```bash
ssh -i ~/.ssh/<your-key>.pem ec2-user@<bastion-public-ip>
```

### SSH to the Private Instance via Bastion

```bash
ssh -i ~/.ssh/<your-key>.pem -J ec2-user@<bastion-public-ip> ec2-user@<private-ip>
```

**Screenshot:** `screenshots/06-bastion-ssh.png`, `screenshots/07-private-instance-ssh.png`

---

## Screenshots

| # | File | Description |
|---|------|-------------|
| 1 | `01-packer-build-success.png` | Packer build completing successfully |
| 2 | `02-ami-created.png` | Custom AMI visible in AWS Console |
| 3 | `03-terraform-apply-success.png` | `terraform apply` output |
| 4 | `04-ec2-instances.png` | Both EC2 instances running in AWS Console |
| 5 | `05-vpc-subnets.png` | VPC and subnet configuration |
| 6 | `06-bastion-ssh.png` | SSH session on the bastion host |
| 7 | `07-private-instance-ssh.png` | SSH session on the private instance via bastion |

---

## Cleanup

```bash
cd terraform/
terraform destroy
```

Then deregister the AMI and delete its snapshot via the AWS Console or CLI.
