#!/bin/bash
set -e

sudo dnf update -y
sudo dnf install -y docker

sudo systemctl enable docker
sudo systemctl start docker

sudo usermod -aG docker ec2-user

sudo mkdir -p /home/ec2-user/.ssh
sudo chmod 700 /home/ec2-user/.ssh

cat <<'EOF' | sudo tee -a /home/ec2-user/.ssh/authorized_keys
${SSH_PUBLIC_KEY}
EOF

sudo chmod 600 /home/ec2-user/.ssh/authorized_keys
sudo chown -R ec2-user:ec2-user /home/ec2-user/.ssh