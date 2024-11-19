#!/bin/bash

# This script installs the AWS Command Line Interface (CLI) on Ubuntu Linux
# Ensure you run this script with superuser privileges (sudo)

# Update the system and install prerequisites
echo "Updating system and installing required packages..."
sudo apt-get update -y && sudo apt-get install -y unzip curl

# Download the AWS CLI installation package
echo "Downloading the AWS CLI installation package..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Unzip the package
echo "Extracting AWS CLI package..."
unzip awscliv2.zip

# Run the installation script
echo "Installing AWS CLI..."
sudo ./aws/install

# Verify the installation
echo "Verifying AWS CLI installation..."
aws --version

# Clean up installation files
echo "Cleaning up installation files..."
rm -rf awscliv2.zip aws

# Done
echo "AWS CLI installation complete. You can now CONFIGURE your AWS CLI........."
echo " You would need your AWS Access Key ID ..., AWS Secret Access Key ..., Default region (us-east-1)..., Default output format (json)..."

