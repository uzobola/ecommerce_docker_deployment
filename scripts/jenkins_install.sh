#!/bin/bash

# =======================================================
# Script to Install Jenkins, Java 17, and Python 3.9
# =======================================================

# Step 1: Update the server
echo "Updating server packages..."
sudo apt update && sudo apt upgrade -y

# Step 2: Install Java 17 (Required for Jenkins) and Python 3.9
echo "Installing Java 17 and Python 3.9..."
sudo apt install -y fontconfig openjdk-17-jre software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt install -y python3.9 python3.9-venv python3-pip

# Step 3: Verify Java installation
echo "Verifying Java installation..."
java -version

# Step 4: Add Jenkins repository key
echo "Adding Jenkins repository key..."
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

# Step 5: Add Jenkins repository
echo "Adding Jenkins repository..."
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Step 6: Update package list again to include Jenkins
echo "Updating package list..."
sudo apt update

# Step 7: Install Jenkins
echo "Installing Jenkins..."
sudo apt install jenkins -y

# Step 8: Start Jenkins service
echo "Starting Jenkins service..."
sudo systemctl start jenkins

# Step 9: Enable Jenkins to start on boot
echo "Enabling Jenkins to start on boot..."
sudo systemctl enable jenkins

# Step 10: Check Jenkins service status
echo "Checking Jenkins status..."
sudo systemctl status jenkins

# Step 11: Display Jenkins initial admin password
echo ""
echo "Initial Jenkins Admin Password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

