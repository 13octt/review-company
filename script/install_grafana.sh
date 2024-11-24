#!/bin/bash

# Cập nhật danh sách gói và cài đặt các phụ thuộc
sudo apt-get update
sudo apt-get install -y apt-transport-https software-properties-common

# Thêm GPG Key cho Grafana
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -

# Thêm kho lưu trữ cho các phiên bản ổn định của Grafana
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

# Cập nhật lại danh sách gói và cài đặt Grafana
sudo apt-get update
sudo apt-get -y install grafana

# Kích hoạt và khởi động dịch vụ Grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# Kiểm tra trạng thái của dịch vụ Grafana
sudo systemctl status grafana-server
