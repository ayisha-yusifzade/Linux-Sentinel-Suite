#!/bin/bash

# ==============================================================================
# SCRIPT: service_guardian.sh
# DESCRIPTION: Advanced Web Service & Port Integrity Monitoring Tool
# AUTHOR: Aisha Yusifzade
# ==============================================================================

# --- CONFIGURATION ---
TARGET_HOST="127.0.0.1"
# List of ports to monitor (e.g., 22 for SSH, 80 for HTTP, 443 for HTTPS)
CRITICAL_PORTS=(22 80 443 8080)
# Web URL to check HTTP Status Code
WEB_URL="http://localhost"

# --- LOGGING SETUP ---
LOG_FILE="./service_monitor.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# --- COLORS ---
G='\033[0;32m'
R='\033[0;31m'
Y='\033[1;33m'
B='\033[0;34m'
NC='\033[0m'

echo -e "${B}====================================================${NC}"
echo -e "${B}       SERVICE GUARDIAN - MONITORING SESSION        ${NC}"
echo -e "${B}====================================================${NC}"
echo "Started at: $TIMESTAMP"

# --- FUNCTION: PORT CHECKER ---
check_ports() {
    echo -e "${Y}[*] Auditing Network Ports on $TARGET_HOST...${NC}"
    for port in "${CRITICAL_PORTS[@]}"; do
        # Using timeout and bash built-in /dev/tcp to check port status
        (echo > /dev/tcp/"$TARGET_HOST"/"$port") >/dev/null 2>&1
        
        if [ $? -eq 0 ]; then
            echo -e "${G}[ONLINE] Port $port is active.${NC}"
        else
            echo -e "${R}[OFFLINE] Port $port is unreachable!${NC}"
            echo "[$TIMESTAMP] ALERT: Port $port is DOWN" >> "$LOG_FILE"
        fi
    done
}

# --- FUNCTION: HTTP STATUS CHECKER ---
check_web_status() {
    echo -e "\n${Y}[*] Checking Web Service Status for $WEB_URL...${NC}"
    
    # Get only the HTTP status code (e.g., 200, 404, 500)
    HTTP_STATUS=$(curl -o /dev/null -s -w "%{http_code}" "$WEB_URL")
    
    if [ "$HTTP_STATUS" -eq 200 ]; then
        echo -e "${G}[SUCCESS] Web Server returned Status 200 (OK).${NC}"
    else
        echo -e "${R}[CRITICAL] Web Server returned Status $HTTP_STATUS!${NC}"
        echo "[$TIMESTAMP] ALERT: Web Service $WEB_URL is returning $HTTP_STATUS" >> "$LOG_FILE"
    fi
}

# --- EXECUTION ---
check_ports
check_web_status

echo -e "\n${B}====================================================${NC}"
echo -e "Monitoring complete. Anomalies are logged in: $LOG_FILE"
