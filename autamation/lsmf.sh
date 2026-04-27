#!/bin/bash

# --- COLOR DEFINITIONS ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# --- HEADER FUNCTION ---
print_header() {
    clear
    echo -e "${MAGENTA}${BOLD}====================================================${NC}"
    echo -e "${MAGENTA}${BOLD}      LINUX SECURITY & MAINTENANCE FRAMEWORK      ${NC}"
    echo -e "${MAGENTA}${BOLD}====================================================${NC}"
    echo -e "${CYAN} System: $(uname -n) | User: $(whoami) | $(date)${NC}\n"
}

# --- MODULE 1: SYSTEM HARDENING & CLEANUP ---
maintenance_module() {
    echo -e "${YELLOW}[*] Initializing System Maintenance...${NC}"
    
    # 1. Package Database Repair & Cleanup
    echo -e "${BLUE}[1/3] Optimizing Pacman Package Database...${NC}"
    sudo pacman -Sc --noconfirm
    
    # 2. Journald Log Vacuuming
    echo -e "${BLUE}[2/3] Vacuuming System Logs (keeping last 1GB)...${NC}"
    sudo journalctl --vacuum-size=1G
    
    # 3. Temp & Cache Purge
    echo -e "${BLUE}[3/3] Clearing Temporary User Caches...${NC}"
    rm -rf ~/.cache/*
    
    echo -e "${GREEN}[✔] Maintenance Complete!${NC}"
    read -p "Press Enter to return to menu..."
}

# --- MODULE 2: RAPID NETWORK AUDIT ---
network_audit_module() {
    echo -e "${YELLOW}[*] Scanning Local Network for Active Hosts...${NC}"
    
    # Auto-detect interface and subnet
    INT=$(ip route | grep default | awk '{print $5}')
    SUBNET=$(ip -o -f inet addr show "$INT" | awk '{print $4}' | cut -d. -f1-3)
    
    echo -e "${CYAN}Target Subnet: $SUBNET.0/24${NC}"
    echo -e "---------------------------------------"
    
    # Parallel Ping Scan
    for i in {1..254}; do
        (
            ping -c 1 -W 1 "$SUBNET.$i" > /dev/null 2>&1
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}[+] Host Found: $SUBNET.$i${NC}"
            fi
        ) &
    done
    wait
    echo -e "---------------------------------------"
    read -p "Scan finished. Press Enter to return..."
}

# --- MODULE 3: SECURITY VULNERABILITY CHECK ---
security_check_module() {
    echo -e "${YELLOW}[*] Running Security Vulnerability Audit...${NC}"
    
    # Check 1: World-writable files in sensitive areas
    echo -e "${BLUE}[!] Checking for dangerous file permissions...${NC}"
    find /etc -maxdepth 2 -type f -perm -o+w 2>/dev/null
    
    # Check 2: Failed Login Attempts
    echo -e "${BLUE}[!] Recent Failed SSH/Login Attempts:${NC}"
    sudo journalctl -u sshd | grep "Failed password" | tail -n 5
    
    # Check 3: Listening Ports (Socket Audit)
    echo -e "${BLUE}[!] Reviewing Open Network Sockets:${NC}"
    ss -tulpn | grep LISTEN
    
    echo -e "${GREEN}[✔] Security Check Finished.${NC}"
    read -p "Press Enter to return..."
}

# --- MODULE 4: SYSTEM RESOURCES REAL-TIME ---
resource_monitor_module() {
    print_header
    echo -e "${YELLOW}[*] Live Resource Monitoring (Press Q to exit)${NC}"
    echo -e "---------------------------------------"
    # Using 'top' in batch mode for a single snapshot
    top -bn1 | head -n 12
    echo -e "---------------------------------------"
    df -h / | awk 'NR==2 {print "Disk Usage: " $5 " used of " $2}'
    read -p "Press Enter to return..."
}

# --- MAIN MENU LOOP ---
while true; do
    print_header
    echo -e "${BOLD}Select a Module:${NC}"
    echo -e "  ${BLUE}1)${NC} System Cleanup & Optimization"
    echo -e "  ${BLUE}2)${NC} Rapid Network Host Discovery"
    echo -e "  ${BLUE}3)${NC} Security Vulnerability Audit"
    echo -e "  ${BLUE}4)${NC} Real-time Resource Monitor"
    echo -e "  ${BLUE}5)${NC} Exit Framework"
    echo -ne "\n${YELLOW}Command > ${NC}"
    read choice

    case $choice in
        1) maintenance_module ;;
        2) network_audit_module ;;
        3) security_check_module ;;
        4) resource_monitor_module ;;
        5) echo -e "${GREEN}Exiting safely. Goodbye!${NC}"; exit 0 ;;
        *) echo -e "${RED}Invalid selection. Try again.${NC}"; sleep 1 ;;
    esac
done
