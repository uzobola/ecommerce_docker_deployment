#!/bin/bash

# ========================================================
# Script to Install Terraform on Ubuntu
# ========================================================


# This script installs Terraform on Ubuntu Linux
# Ensure you run this script with superuser privileges (sudo)

# Update the system and install required packages
echo "Updating system and installing required packages..."
sudo apt-get update -y && sudo apt-get install -y gnupg software-properties-common curl

# Install the HashiCorp GPG key
echo "Installing HashiCorp GPG key..."
wget -qO- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

# Verify the GPG key's fingerprint (optional but recommended)
echo "Verifying GPG key fingerprint..."
gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint

# Add the official HashiCorp repository to the system
echo "Adding HashiCorp repository..."
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Update package information from the new repository
echo "Updating package information..."
sudo apt-get update -y

# Install Terraform
echo "Installing Terraform..."
sudo apt-get install -y terraform

# Verify the installation
echo "Verifying Terraform installation..."
terraform --version
terraform -help

# Enable bash autocomplete for Terraform
echo "Enabling Terraform autocomplete for bash..."
terraform -install-autocomplete

# Done
echo "Terraform installation complete. You can now use Terraform!"

