#!/bin/bash

# Cập nhật hệ thống
echo "Updating system packages..."
sudo apt update -y
sudo apt upgrade -y

# Cài đặt PostgreSQL
echo "Installing PostgreSQL..."
sudo apt install -y postgresql postgresql-contrib

# Cài đặt Java (SonarQube yêu cầu Java 11)
echo "Installing Java 11..."
sudo apt install -y openjdk-11-jdk

# Tạo người dùng và cơ sở dữ liệu cho SonarQube trong PostgreSQL
echo "Creating SonarQube user and database..."
sudo -u postgres psql -c "CREATE USER sonar WITH PASSWORD 'sonarpassword';"
sudo -u postgres psql -c "CREATE DATABASE sonar_db WITH OWNER sonar;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE sonar_db TO sonar;"

# Cài đặt wget và unzip (nếu chưa có)
echo "Installing wget and unzip..."
sudo apt install -y wget unzip

# Tải SonarQube
echo "Downloading SonarQube..."
# SONAR_VERSION="9.7.1.62043"
SONAR_VERSION="10.7.0.96327"
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${SONAR_VERSION}.zip

# Giải nén SonarQube
echo "Extracting SonarQube..."
unzip sonarqube-${SONAR_VERSION}.zip

# Di chuyển thư mục SonarQube vào thư mục thích hợp
echo "Moving SonarQube to /opt/sonarqube..."
sudo mv sonarqube-${SONAR_VERSION} /opt/sonarqube

# Tạo người dùng SonarQube
echo "Creating SonarQube user..."
sudo useradd sonar
sudo passwd sonar

# Cấu hình SonarQube sử dụng PostgreSQL
echo "Configuring SonarQube to use PostgreSQL..."
sudo sed -i 's|#sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonar|sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonar_db|' /opt/sonarqube/conf/sonar.properties
sudo sed -i 's|#sonar.jdbc.username=sonar|sonar.jdbc.username=sonar|' /opt/sonarqube/conf/sonar.properties
sudo sed -i 's|#sonar.jdbc.password=sonarpassword|sonar.jdbc.password=sonarpassword|' /opt/sonarqube/conf/sonar.properties

# Cấp quyền cho người dùng SonarQube
echo "Setting permissions for SonarQube..."
sudo chown -R sonar:sonar /opt/sonarqube

# Tạo dịch vụ systemd để quản lý SonarQube
echo "Creating SonarQube systemd service..."
sudo bash -c 'cat << EOF > /etc/systemd/system/sonarqube.service
[Unit]
Description=SonarQube
After=network.target

[Service]
Type=forking
User=sonar
Group=sonar
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF'

# Khởi động dịch vụ SonarQube
echo "Starting SonarQube service..."
sudo systemctl daemon-reload
sudo systemctl start sonarqube
sudo systemctl enable sonarqube

# Kiểm tra trạng thái dịch vụ SonarQube
echo "Checking SonarQube service status..."
sudo systemctl status sonarqube

# Hoàn tất
echo "SonarQube installation and configuration complete!"
echo "You can access SonarQube at http://<EC2-IP>:9000"
echo "Default login: admin / admin"
