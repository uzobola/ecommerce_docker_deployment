#!/bin/bash

# This script installs Docker and ensures that any conflicting packages are removed.

# Step 1: Uninstall any conflicting packages
echo "Removing conflicting packages..."
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do 
  sudo apt-get remove -y $pkg
done


# Step 2: Install necessary dependencies for Docker installation
echo "Installing required dependencies..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl


# Step 3: Add Docker's official GPG key
echo "Adding Docker's GPG key..."
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc


# Step 4: Add Docker repository to APT sources
echo "Adding Docker repository to APT sources..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


# Step 5: Update APT repositories
echo "Updating APT repositories..."
sudo apt-get update


# Step 6: Install Docker and associated components
echo "Installing Docker and related components..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


# Step 7: Create the docker group
echo "Creating docker group..."
sudo groupadd docker


# Step 8: Add your user to the docker group
echo "Adding the current user to the docker group..."
sudo usermod -aG docker $USER



# Step 9: Activate the changes to groups
echo "Activating the group changes..."
newgrp docker
echo 
echo "Docker installation completed. Please log out and log back in for the changes to take effect."


# Step 10: Install Docker-Compose
echo " Installing Docker-compose"
sudo apt-get install -y docker-compose
echo "Docker compose installation complete"
