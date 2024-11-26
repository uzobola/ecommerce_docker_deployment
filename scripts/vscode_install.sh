#!/bin/bash

# Install code-server
curl -L https://code-server.dev/install.sh | sh

# Enable and start code-server service using systemctl
sudo systemctl enable --now code-server@$USER

# Brief pause to ensure the service is properly enabled
sleep 1

# Restart the code-server service
sudo systemctl restart code-server@$USER

# Configure code-server with custom settings
CONFIG_PATH="$HOME/.config/code-server/config.yaml"

# Write configuration to the config.yaml file
echo "bind-addr: 0.0.0.0:8081
auth: password
password: abcd1234
cert: false" > "$CONFIG_PATH"
