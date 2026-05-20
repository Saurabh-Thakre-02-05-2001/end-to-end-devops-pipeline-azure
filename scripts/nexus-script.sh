#!/bin/bash

# Update packages
apt update -y

# Install Java + wget
apt install openjdk-17-jdk openjdk-17-jre wget -y

# Go to /opt
cd /opt

# Download Nexus
wget https://download.sonatype.com/nexus/3/nexus-3.84.1-01-linux-x86_64.tar.gz

# Extract Nexus
tar -xvzf nexus-3.84.1-01-linux-x86_64.tar.gz

# Rename folder
mv nexus-3.84.1-01 nexus

# Create nexus user
adduser --disabled-password --gecos "" nexus

# Permissions
chown -R nexus:nexus /opt/nexus
chown -R nexus:nexus /opt/sonatype-work

# Configure nexus user
sed -i 's/#run_as_user=""/run_as_user="nexus"/g' /opt/nexus/bin/nexus.rc

# Create systemd service
cat <<EOF > /etc/systemd/system/nexus.service
[Unit]
Description=Nexus Service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
ExecStart=/opt/nexus/bin/nexus start
ExecStop=/opt/nexus/bin/nexus stop
User=nexus
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd
systemctl daemon-reload

# Enable and start nexus
systemctl enable nexus
systemctl start nexus

# Open firewall
ufw allow 8081/tcp

# Show status
systemctl status nexus

echo "=================================="
echo "NEXUS INSTALLATION COMPLETED"
echo "Open in browser:"
echo "http://SERVER_IP:8081"
echo "=================================="
