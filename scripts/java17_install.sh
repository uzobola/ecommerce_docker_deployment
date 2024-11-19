!/bin/bash

# Install Java 17

# Update system
echo "Updating system..."
sudo apt update

# Install Java 17
echo "Installing Java 17..."
sudo apt install openjdk-17-jdk openjdk-17-jre -y

# Verify Java installation
echo "Verifying Java installation..."
java -version
