#!/bin/bash
# Update packages
apt update -y
# Install Java and unzip
apt install openjdk-11-jdk unzip wget -y
# Move to /opt
cd /opt/
# Download SonarQube
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.9.6.50800.zip
# Unzip package
unzip sonarqube-8.9.6.50800.zip
# Create sonar user if not exists
id sonar &>/dev/null || useradd -m -d /home/sonar sonar
# Change ownership
chown -R sonar:sonar /opt/sonarqube-8.9.6.50800
# Give permissions
chmod -R 755 /opt/sonarqube-8.9.6.50800
# Start SonarQube as sonar user
sudo -u sonar bash <<EOF
cd /opt/sonarqube-8.9.6.50800/bin/linux-x86-64
./sonar.sh start
EOF
# Check status
sleep 10
sudo -u sonar bash <<EOF
cd /opt/sonarqube-8.9.6.50800/bin/linux-x86-64
./sonar.sh status
EOF
echo "SonarQube started successfully"
echo "Open browser: http://YOUR_SERVER_IP:9000"
echo "Username: admin"
echo "Password: admin"
