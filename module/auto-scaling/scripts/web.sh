#!/bin/bash
set -e

# === Log file Setup ===
LOG_FILE="/var/log/web-setup.log"
touch $LOG_FILE
chmod 644 $LOG_FILE

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a $LOG_FILE
}

log "Starting user data script..."

# === Environment Variables ===
s3_bucket="${s3_bucket}"
alb_dns="${alb_dns}"

log "Using S3 bucket: $s3_bucket"
log "Using ALB DNS: $alb_dns"

# === System Updates and Tools ===
log "Updating system and installing base packages..."
sudo apt update -y && sudo apt install -y unzip curl && log "Base packages installed"

# === Install AWS CLI ===
cd /tmp
log "Installing AWS CLI..."
curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
./aws/install && log "AWS CLI installed successfully"

# === Set PATH for AWS CLI ===
export PATH=$PATH:/usr/local/bin
aws --version | tee -a $LOG_FILE


# === Install Node.js, NVM, and PM2 as 'ubuntu' user ===
log "Installing Node.js, NVM, and PM2 for ubuntu user..."

sudo -i -u ubuntu bash <<'EOF'
cd ~
export NVM_DIR="$HOME/.nvm"
curl -o- https://raw.githubusercontent.com/avizway1/aws_3tier_architecture/main/install.sh | bash
source "$NVM_DIR/nvm.sh"
nvm install 16
nvm use 16
npm install -g pm2
EOF

log "Node.js, NVM, and PM2 installed successfully under ubuntu user."

# === Copy application code from S3 ===
cd /home/ubuntu
log "Copying app code from S3..."
aws s3 cp s3://$s3_bucket/aws_3tier_architecture/application-code/web-tier/ web-tier --recursive && \
log "App code copied successfully"

sudo chown -R ubuntu:ubuntu /home/ubuntu/web-tier && log "Ownership of web-tier folder set to ubuntu user"

log "Installing app dependencies and building React app..."

sudo -i -u ubuntu bash <<'EOF'
cd ~/web-tier
export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"
nvm use 16
npm install
npm run build
EOF

log "App dependencies installed and built successfully"


# === Install and configure Nginx ===
log "Installing Nginx..."
sudo apt update -y
sudo apt install nginx -y && log "Nginx installed"

log "Configuring Nginx..."
sudo rm -f /etc/nginx/nginx.conf && log "Old nginx.conf removed"
sudo aws s3 cp s3://$s3_bucket/aws_3tier_architecture/nginx.conf /etc/nginx/nginx.conf && log "New nginx.conf downloaded from S3"

# Replace placeholder ALB DNS
sudo sed -i "s|__ALB_DNS__|$alb_dns|g" /etc/nginx/nginx.conf && log "ALB DNS replaced"

# Restart and enable Nginx
sudo nginx -t && sudo systemctl restart nginx && log "Nginx tested and restarted"
sudo systemctl enable nginx && log "Nginx enabled to start on boot"

# Set permissions (change if user is 'ubuntu')
chmod -R 755 /home/ubuntu && log "Permissions set on /home/ubuntu"

log "User data script completed successfully."