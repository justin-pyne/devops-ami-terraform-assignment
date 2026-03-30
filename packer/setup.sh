#!/usr/bin/env bash
# setup.sh — Installs Docker on Amazon Linux 2 and configures it to start on boot.
# Executed by Packer during AMI creation.

set -euo pipefail

echo "######################################"
echo "#  Starting Docker installation       "
echo "######################################"

# Update all packages
yum update -y

# Install Docker from the Amazon Linux extras repository
amazon-linux-extras install docker -y

# Start Docker and enable it to run at boot
systemctl start docker
systemctl enable docker

# Add ec2-user to the docker group so it can run Docker without sudo
usermod -aG docker ec2-user

# Install Docker Compose (v2 plugin style)
DOCKER_COMPOSE_VERSION="v2.27.0"
DOCKER_COMPOSE_DEST="/usr/local/lib/docker/cli-plugins"
mkdir -p "${DOCKER_COMPOSE_DEST}"
curl -SL "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-linux-x86_64" \
  -o "${DOCKER_COMPOSE_DEST}/docker-compose"
chmod +x "${DOCKER_COMPOSE_DEST}/docker-compose"

# Convenience symlink so `docker-compose` (v1 style) still works
ln -sf "${DOCKER_COMPOSE_DEST}/docker-compose" /usr/local/bin/docker-compose

echo "######################################"
echo "#  Verifying installation             "
echo "######################################"

docker --version
docker compose version

echo "######################################"
echo "#  Docker setup complete              "
echo "######################################"
