#!/bin/bash

# Step 1: Create a dedicated user for Prometheus
echo "Creating dedicated Prometheus user..."
sudo useradd --system --no-create-home --shell /bin/false prometheus

# Step 2: Download Prometheus
echo "Downloading Prometheus..."
wget https://github.com/prometheus/prometheus/releases/download/v2.47.1/prometheus-2.47.1.linux-amd64.tar.gz

# Step 3: Extract Prometheus files
echo "Extracting Prometheus files..."
tar -xvf prometheus-2.47.1.linux-amd64.tar.gz
cd prometheus-2.47.1.linux-amd64/

# Step 4: Create necessary directories
echo "Creating necessary directories..."
sudo mkdir -p /data /etc/prometheus

# Step 5: Move files to appropriate locations
echo "Moving files to appropriate directories..."
sudo mv prometheus promtool /usr/local/bin/
sudo mv consoles/ console_libraries/ /etc/prometheus/
sudo mv prometheus.yml /etc/prometheus/prometheus.yml

# Step 6: Set ownership of directories
echo "Setting ownership for directories..."
sudo chown -R prometheus:prometheus /etc/prometheus/ /data/

# Step 7: Create systemd service configuration for Prometheus
echo "Creating Prometheus systemd service file..."
sudo bash -c 'cat > /etc/systemd/system/prometheus.service << EOF
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target
StartLimitIntervalSec=500
StartLimitBurst=5

[Service]
User=prometheus
Group=prometheus
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/data \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries \
  --web.listen-address=0.0.0.0:9090 \
  --web.enable-lifecycle

[Install]
WantedBy=multi-user.target
EOF'

# Step 8: Enable and start Prometheus
echo "Enabling and starting Prometheus..."
sudo systemctl enable prometheus
sudo systemctl start prometheus

# Step 9: Check the status of Prometheus
echo "Checking Prometheus status..."
sudo systemctl status prometheus
