# ===========================================================================
# VPC
# ===========================================================================

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name      = "${var.project_name}-vpc"
    ManagedBy = "Terraform"
  }
}

# ===========================================================================
# Internet Gateway
# ===========================================================================

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name      = "${var.project_name}-igw"
    ManagedBy = "Terraform"
  }
}

# ===========================================================================
# Subnets
# ===========================================================================

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name      = "${var.project_name}-public-subnet"
    ManagedBy = "Terraform"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "${var.aws_region}a"

  tags = {
    Name      = "${var.project_name}-private-subnet"
    ManagedBy = "Terraform"
  }
}

# ===========================================================================
# Route Tables
# ===========================================================================

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name      = "${var.project_name}-public-rt"
    ManagedBy = "Terraform"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Private subnet has no route to the internet (intentionally isolated)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name      = "${var.project_name}-private-rt"
    ManagedBy = "Terraform"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# ===========================================================================
# Security Groups
# ===========================================================================

# Bastion — allows SSH from a trusted CIDR
resource "aws_security_group" "bastion" {
  name        = "${var.project_name}-bastion-sg"
  description = "Allow SSH inbound from trusted IP; all outbound"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from trusted IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.project_name}-bastion-sg"
    ManagedBy = "Terraform"
  }
}

# Private instance — allows SSH only from the bastion security group
resource "aws_security_group" "private" {
  name        = "${var.project_name}-private-sg"
  description = "Allow SSH inbound from bastion only; all outbound"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "SSH from bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.project_name}-private-sg"
    ManagedBy = "Terraform"
  }
}

# ===========================================================================
# EC2 Instances
# ===========================================================================

resource "aws_instance" "bastion" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.bastion.id]

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name      = "${var.project_name}-bastion"
    Role      = "bastion"
    ManagedBy = "Terraform"
  }
}

resource "aws_instance" "private" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private.id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.private.id]

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name      = "${var.project_name}-private"
    Role      = "private"
    ManagedBy = "Terraform"
  }
}
