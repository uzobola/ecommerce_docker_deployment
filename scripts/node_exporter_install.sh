#!/bin/bash

# Install wget if not already installed
echo "Installing wget..."
sudo apt install wget -y

# Define Node Exporter version. 
# Makes it easy incase i want to change versions.
NODE_EXPORTER_VERSION="1.5.0"

# Download and install Node Exporter
echo "Downloading and installing Node Exporter version ${NODE_EXPORTER_VERSION}..."
wget https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
tar xvfz node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
sudo mv node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64/node_exporter /usr/local/bin/
rm -rf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64*

# Create a Node Exporter user
echo "Creating Node Exporter user..."
sudo useradd --no-create-home --shell /bin/false node_exporter

# Create Node Exporter service file
echo "Creating Node Exporter service..."
cat << EOF | sudo tee /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, start and enable Node Exporter service
echo "Reloading systemd and starting Node Exporter service..."
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter

# Print the public IP address and Node Exporter port
echo "Node Exporter installation complete. It's accessible at http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):9100/metrics"

