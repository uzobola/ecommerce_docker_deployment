#!/bin/bash


# ========================================================
# Script to Install Prometheus and Grafana
# ========================================================


# Update the system
echo "Updating system..."
sudo apt update -y && sudo apt upgrade -y

# Install wget
echo "Installing wget..."
sudo apt install wget -y

# Install Prometheus
echo "Downloading and installing Prometheus..."
wget https://github.com/prometheus/prometheus/releases/download/v2.37.0/prometheus-2.37.0.linux-amd64.tar.gz
tar xvfz prometheus-2.37.0.linux-amd64.tar.gz
sudo mv prometheus-2.37.0.linux-amd64 /opt/prometheus

# Create a Prometheus user
echo "Creating Prometheus user..."
sudo useradd --no-create-home --shell /bin/false prometheus

# Set ownership for Prometheus directories
echo "Setting ownership for Prometheus directories..."
sudo chown -R prometheus:prometheus /opt/prometheus

# Create a Prometheus service file
echo "Creating Prometheus service..."
cat << EOF | sudo tee /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/opt/prometheus/prometheus \
    --config.file /opt/prometheus/prometheus.yml \
    --storage.tsdb.path /opt/prometheus/data

[Install]
WantedBy=multi-user.target
EOF

# Start and enable Prometheus service
echo "Starting and enabling Prometheus service..."
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus

# Install Grafana
echo "Installing Grafana..."
# Add Grafana GPG key and repository
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
sudo add-apt-repository -y "deb https://packages.grafana.com/oss/deb stable main"

# Update package list and install Grafana
sudo apt update -y
sudo apt install grafana -y

# Start and enable Grafana service
echo "Starting and enabling Grafana service..."
sudo systemctl start grafana-server
sudo systemctl enable grafana-server

# Print the public IP address
echo "Installation complete. Access Prometheus at http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):9090"
echo "Access Grafana at http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):3000"
echo "Default Grafana login is admin/admin"

# Add Node Exporter job to Prometheus config
echo "Adding Node Exporter job to Prometheus configuration..."
cat << EOF | sudo tee -a /opt/prometheus/prometheus.yml
  - job_name: 'node_exporter'
    static_configs:
      - targets: ['localhost:9100']                  ###<----CHANGE 'localhost' to private IP of target instance
EOF

# Restart Prometheus to apply the new configuration
echo "Restarting Prometheus to apply the new configuration..."
sudo systemctl restart prometheus

echo "Node Exporter job added to Prometheus configuration. Prometheus has been restarted."

