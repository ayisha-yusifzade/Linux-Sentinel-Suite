#!/bin/bash

# --- CONFIGURATION ---
CPU_THRESHOLD=80
RAM_THRESHOLD=80
DISK_THRESHOLD=90

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}==========================================${NC}"
echo -e "${BLUE}      SYSTEM PERFORMANCE DASHBOARD        ${NC}"
echo -e "${BLUE}==========================================${NC}"

# 1. CPU Usage Analysis
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}' | cut -d. -f1)
echo -n "CPU Usage: $CPU_USAGE% "
if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]; then
    echo -e "${RED}[CRITICAL - High CPU Load!]${NC}"
else
    echo -e "${GREEN}[OK]${NC}"
fi

# 2. RAM Usage Analysis
RAM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}' | cut -d. -f1)
echo -n "RAM Usage: $RAM_USAGE% "
if [ "$RAM_USAGE" -gt "$RAM_THRESHOLD" ]; then
    echo -e "${RED}[CRITICAL - Low Memory!]${NC}"
else
    echo -e "${GREEN}[OK]${NC}"
fi

# 3. Disk Space Analysis (Root Partition)
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
echo -n "Disk Usage: $DISK_USAGE% "
if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    echo -e "${RED}[CRITICAL - Disk Almost Full!]${NC}"
else
    echo -e "${GREEN}[OK]${NC}"
fi

# 4. Resource Hogs (Top 5 Processes by CPU)
echo -e "\n${YELLOW}Top 5 Resource Consuming Processes (CPU):${NC}"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6 | column -t

# 5. System Uptime & Load Average
echo -e "\n${BLUE}------------------------------------------${NC}"
echo -n "System Uptime: "
uptime -p
echo -e "${BLUE}------------------------------------------${NC}"
