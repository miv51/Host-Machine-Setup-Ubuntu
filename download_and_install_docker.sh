#!/bin/bash

# Script to install and initialize Docker on an Ubuntu host for remote image building and running.
# Assumes SSH is already fully configured for remote access to this host.

set -e # Exit immediately if a command exits with a non-zero status.

echo "----------------------------------------------------"
echo "  Starting Docker Installation and Initialization  "
echo "----------------------------------------------------"

# --- 1. Update Package Index ---
echo "Updating package index..."
sudo apt update

# --- 2. Install Prerequisites ---
echo "Installing prerequisite packages..."
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release

# --- 3. Add Docker's Official GPG Key ---
echo "Adding Docker's GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# --- 4. Add the Docker Repository to APT Sources ---
echo "Adding Docker repository to APT sources..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# --- 5. Update Package Index Again ---
echo "Updating package index after adding Docker repository..."
sudo apt update

# --- 6. Install Docker Engine, CLI, containerd, and Compose Plugin ---
echo "Installing Docker Engine, CLI, containerd, and Docker Compose Plugin..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# --- 7. Verify Docker Installation ---
echo "Verifying Docker installation..."
sudo docker run hello-world

echo "Docker Engine installed successfully!"

# --- 8. (Optional but Recommended) Add User to the Docker Group ---
echo "Adding the current user ($USER) to the docker group (optional)..."
echo "This allows you to run Docker commands without sudo."
sudo usermod -aG docker "$USER"
echo "You may need to log out and log back in for this change to take effect, or run 'newgrp docker'."

echo "----------------------------------------------------"
echo "  Docker Installation and Initialization Complete!  "
echo "----------------------------------------------------"
echo "You should now be able to build and run Docker images on this host."
echo "Since SSH is configured, you can securely manage Docker remotely using the standard Docker CLI on your local machine."
echo "Consider using SSH tunneling with the '-L' flag to forward the Docker socket securely if needed for direct Docker CLI access."
