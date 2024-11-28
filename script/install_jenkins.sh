#!/bin/bash

# Update the system
sudo apt update && sudo apt upgrade -y

# Install prerequisites
sudo apt install -y openjdk-17-jdk curl gnupg software-properties-common unzip

# Add Jenkins repository
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Install Jenkins
sudo apt update && sudo apt install -y jenkins

# Start and enable Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Install Docker
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo chmod 666 /var/run/docker.sock

# Add Jenkins user to the Docker group
sudo usermod -aG docker jenkins

# Install Trivy
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh -s -- -b /usr/local/bin

# Verify Trivy installation
if command -v trivy &> /dev/null; then
  echo "Trivy installed successfully!"
else
  echo "Trivy installation failed!"
  exit 1
fi

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Verify kubectl installation
if command -v kubectl &> /dev/null; then
  echo "kubectl installed successfully!"
else
  echo "kubectl installation failed!"
  exit 1
fi

# Output initial Jenkins admin password
echo "Jenkins installation completed. Retrieve the admin password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# Jenkins setup instructions
echo -e "\nAccess Jenkins at: http://<your-server-ip>:8080"
echo -e "Use the above password to complete the setup.\n"

# Reminder for Trivy and kubectl
echo -e "Trivy and kubectl are installed and ready for integration into your Jenkins pipelines."

