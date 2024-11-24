#!/bin/bash

# Step 1: Create a dedicated user for Node Exporter
echo "Creating dedicated Node Exporter user..."
sudo useradd --system --no-create-home --shell /bin/false node_exporter

# Step 2: Download Node Exporter
echo "Downloading Node Exporter..."
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz

# Step 3: Extract Node Exporter files and clean up
echo "Extracting Node Exporter files..."
tar -xvf node_exporter-1.6.1.linux-amd64.tar.gz

# Move the binary to /usr/local/bin/
echo "Moving Node Exporter binary to /usr/local/bin/"
sudo mv node_exporter-1.6.1.linux-amd64/node_exporter /usr/local/bin/

# Clean up downloaded files
echo "Cleaning up extracted files..."
rm -rf node_exporter*

# Step 4: Create systemd service configuration for Node Exporter
echo "Creating Node Exporter systemd service file..."
sudo bash -c 'cat > /etc/systemd/system/node_exporter.service << EOF
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=default.target
EOF'

# Step 5: Set permissions for the Node Exporter binary
echo "Setting permissions for Node Exporter binary..."
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

# Step 6: Reload systemd daemon and start Node Exporter
echo "Reloading systemd daemon and starting Node Exporter..."
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter

# Step 7: Check the status of Node Exporter
echo "Checking Node Exporter status..."
sudo systemctl status node_exporter
