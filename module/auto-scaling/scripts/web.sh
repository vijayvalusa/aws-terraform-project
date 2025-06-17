#!/bin/bash
set -e
exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

# === Log file Setup ===
LOG_FILE="/var/log/app-setup.log"
touch $LOG_FILE
chmod 644 $LOG_FILE

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a $LOG_FILE
}

log "Starting user data script..."

# === Environment Variables ===
s3_bucket="${s3_bucket}"
alb_dns="${alb_dns}"

# === Install AWS CLI v2 ===
cd /tmp
log "Downloading AWS CLI..."
curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install && log "AWS CLI installed successfully"
export PATH=$PATH:/usr/local/bin
aws --version | tee -a $LOG_FILE

# === Install Node.js, NVM, and PM2 ===
log "Installing Node.js, NVM, and PM2..."
curl -o- https://raw.githubusercontent.com/avizway1/aws_3tier_architecture/main/install.sh | bash
source ~/.bashrc
nvm install 16 && log "Node.js v16 installed"
nvm use 16
npm install -g pm2 && log "PM2 installed"

# === Copy application code from S3 ===
cd ~
log "Copying app code from S3..."
aws s3 cp s3://$s3_bucket/aws_3tier_architecture/application-code/web-tier/ web-tier --recursive && \
log "App code copied successfully"
cd ~/web-tier
npm install && log "npm dependencies installed"
npm run build && log "App built successfully"

# === Install and configure Nginx ===
sudo apt install nginx -y && log "Nginx installed"

cd /etc/nginx
ls | tee -a $LOG_FILE

sudo rm -f nginx.conf && log "Old nginx.conf removed"
sudo aws s3 cp s3://3tierproject-avinash/application-code/nginx.conf . && log "New nginx.conf downloaded from S3"

# Replace placeholder ALB DNS (optional)
sudo sed -i "s|__ALB_DNS__|$alb_dns|g" /etc/nginx/nginx.conf && log "ALB DNS replaced"

# Restart and enable Nginx
sudo nginx -t && sudo systemctl restart nginx && log "Nginx tested and restarted"
sudo service nginx restart && log "Nginx restarted using 'service'"

chmod -R 755 /home/ec2-user && log "Permissions set on /home/ec2-user"

sudo chkconfig nginx on && log "Nginx configured to start on boot"

log "User data script completed successfully."