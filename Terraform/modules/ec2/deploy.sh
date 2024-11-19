#!/bin/bash

# STEP 1: Install Docker and Docker Compose
# 1: Uninstall any conflicting packages
echo "Removing conflicting packages..."
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do 
  sudo apt-get remove -y $pkg
done

# 2: Install necessary dependencies for Docker installation
echo "Installing required dependencies..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl

# 3: Add Docker's official GPG key
echo "Adding Docker's GPG key..."
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# 4: Add Docker repository to APT sources
echo "Adding Docker repository to APT sources..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 5: Update APT repositories
echo "Updating APT repositories..."
sudo apt-get update

# 6: Install Docker and docker-compose
echo "Installing Docker and related components..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose

# 7: Create the docker group
echo "Creating docker group..."
sudo groupadd docker

# 8: Add your user to the docker group
echo "Adding the current user to the docker group..."
sudo usermod -aG docker $USER

# 9: Activate the changes to groups
echo "Activating the group changes..."
newgrp docker
echo 
echo "Docker installation completed. Please log out and log back in for the changes to take effect."


# STEP 2. Log in to DockerHub
echo "Logging into DockerHub..."
echo "$docker_pass" | docker login --username "$docker_user" --password-stdin
echo "DockerHub login succeeded."


# STEP 3. Create the docker-compose.yml file
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Creating app directory..."
mkdir -p /app
cd /app
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Created and moved to /app"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Creating docker-compose.yml..."
cat > docker-compose.yml <<EOF
${docker_compose}
EOF
echo "[$(date '+%Y-%m-%d %H:%M:%S')] docker-compose.yml created."


# STEP 4. Pull Docker images
echo "Pulling Docker images..."
docker-compose pull
echo " Docker images pulled"


# STEP 5. Start the containers
echo "Starting containers..."
docker-compose up -d --force-recreate
echo "Containers started."

# STEP 6. Clean up the system
echo "Cleaning up..."
docker system prune -f

# STEP 7. Log out of DockerHub
echo "Logging out of DockerHub..."
docker logout
echo "DockerHub logout succeeded."

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Deployment complete!"
