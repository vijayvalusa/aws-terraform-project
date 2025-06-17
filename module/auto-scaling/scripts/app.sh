#!/bin/bash
set -e

# === Log file setup ===
LOG_FILE="/var/log/app-setup.log"
touch $LOG_FILE
chmod 644 $LOG_FILE

log() {
  echo "[`date`] $1" | tee -a $LOG_FILE
}

log "==== Starting script execution ===="

# === Environment Variables ===
db_endpoint="${db_endpoint}"
db_username="${db_username}"
db_password="${db_password}"
s3_bucket="${s3_bucket}"

log "Using DB endpoint: $db_endpoint"
log "Using S3 bucket: $s3_bucket"
log "Using S3 bucket: $db_username"
log "Using S3 bucket: $db_password"

# === System Updates and Tools ===
log "Updating system and installing base packages..."
apt update -y && apt install mysql-client unzip curl -y && log "Base packages installed"

# === Install AWS CLI ===
cd /tmp
log "Installing AWS CLI..."
curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
./aws/install && log "AWS CLI installed successfully"

# === Set PATH for AWS CLI ===
export PATH=$PATH:/usr/local/bin
aws --version | tee -a $LOG_FILE

# === MySQL Setup ===
log "Connecting to MySQL and setting up database..."
mysql -h "$db_endpoint" -u "$db_username" -p"$db_password" <<EOF
CREATE DATABASE IF NOT EXISTS webappdb;
USE webappdb;
CREATE TABLE IF NOT EXISTS transactions(
  id INT NOT NULL AUTO_INCREMENT,
  amount DECIMAL(10,2),
  description VARCHAR(100),
  PRIMARY KEY(id)
);
INSERT INTO transactions (amount, description) VALUES ('400', 'groceries');
EOF
log "MySQL setup complete"

# === Node/NVM/PM2 Setup ===
export HOME=/root
log "Installing Node.js, NVM, and PM2...$HOME"
curl -o- https://raw.githubusercontent.com/avizway1/aws_3tier_architecture/main/install.sh | bash
export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"
nvm install 16
nvm use 16
npm install -g pm2
log "Node.js and PM2 installed"

# === App Code from S3 ===
cd /root
log "Fetching app code from S3..."
aws s3 cp s3://$s3_bucket/aws_3tier_architecture/application-code/app-tier/ app-tier --recursive && \
log "App code copied successfully" || \
log "ERROR: Failed to copy app code from S3"

# === Configure App ===
cd app-tier
cat > DbConfig.js <<EOF
module.exports = {
  HOST: "${db_endpoint}",
  USER: "${db_username}",
  PASSWORD: "${db_password}",
  DB: "webappdb"
};
EOF
log "DbConfig.js written"

npm install && log "NPM packages installed"
pm2 start index.js && pm2 save && pm2 startup && log "App started with PM2"

log "==== Script completed successfully ===="
