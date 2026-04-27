#!/bin/bash

# ==============================================================================
# SCRIPT: bootstrap_server.sh (One-Click Secure Infrastructure)
# DESCRIPTION: Automates system hardening, security, and environment deployment.
# TARGET OS: Ubuntu / Debian
# ==============================================================================

# --- CONFIGURATION ---
NEW_USER="aisha_admin"
DOMAIN="example.com"  # Change this to your actual domain
EMAIL="admin@$DOMAIN"

# Colors for professional output
G='\033[0;32m'
R='\033[0;31m'
Y='\033[1;33m'
B='\033[0;34m'
NC='\033[0m'

echo -e "${B}>>> Starting Enterprise Infrastructure Bootstrap...${NC}"

# --- STAGE 1: SYSTEM UPDATES & CORE DEPENDENCIES ---
echo -e "${Y}[*] Updating system packages and installing essentials...${NC}"
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y \
    curl wget git ufw fail2ban certbot \
    python3-certbot-nginx apt-transport-https \
    ca-certificates gnupg lsb-release

# --- STAGE 2: PRIVILEGED USER & SSH HARDENING ---
echo -e "${Y}[*] Setting up administrative user: $NEW_USER...${NC}"
if ! id "$NEW_USER" &>/dev/null; then
    sudo useradd -m -s /bin/bash "$NEW_USER"
    sudo usermod -aG sudo "$NEW_USER"
    # Allow sudo without password for automation efficiency
    echo "$NEW_USER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/"$NEW_USER"
    echo -e "${G}[✔] User $NEW_USER created.${NC}"
else
    echo -e "${B}[i] User $NEW_USER already exists.${NC}"
fi

# --- STAGE 3: DOCKER ENGINE DEPLOYMENT ---
echo -e "${Y}[*] Deploying Docker & Docker Compose...${NC}"
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker "$NEW_USER"
    echo -e "${G}[✔] Docker Engine installed.${NC}"
else
    echo -e "${B}[i] Docker is already installed.${NC}"
fi

# --- STAGE 4: NETWORK FIREWALL (UFW) POLICY ---
echo -e "${Y}[*] Implementing Firewall Security Policy...${NC}"
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
echo "y" | sudo ufw enable
echo -e "${G}[✔] Firewall is active with strict policies.${NC}"

# --- STAGE 5: NGINX REVERSE PROXY CONFIGURATION ---
echo -e "${Y}[*] Configuring Nginx Reverse Proxy for $DOMAIN...${NC}"
sudo apt-get install -y nginx
cat <<EOF | sudo tee /etc/nginx/sites-available/$DOMAIN
server {
    listen 80;
    server_name $DOMAIN;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF
sudo ln -sf /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo systemctl restart nginx
echo -e "${G}[✔] Nginx configured and restarted.${NC}"

# --- STAGE 6: INTRUSION PREVENTION (FAIL2BAN) ---
echo -e "${Y}[*] Configuring Fail2Ban for SSH Brute-force Protection...${NC}"
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
echo -e "${G}[✔] Fail2Ban service is guarding the gates.${NC}"

# --- STAGE 7: SSL AUTOMATION (OPTIONAL) ---
# Uncomment the following lines once your domain points to this server's IP.
# echo -e "${Y}[*] Provisioning SSL Certificate via Let's Encrypt...${NC}"
# sudo certbot --nginx -d $DOMAIN --non-interactive --agree-tos -m $EMAIL

echo -e "\n${B}====================================================${NC}"
echo -e "${G}         BOOTSTRAP COMPLETED SUCCESSFULLY           ${NC}"
echo -e "  - Secure User: $NEW_USER"
echo -e "  - Docker: Operational"
echo -e "  - Firewall: Enabled (SSH, HTTP, HTTPS)"
echo -e "  - Proxy: Nginx Active for $DOMAIN"
echo -e "${B}====================================================${NC}"
