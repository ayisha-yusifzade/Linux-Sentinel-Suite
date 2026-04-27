#!/bin/bash

# ==============================================================================
# SCRIPT: sys_dashboard.sh
# DESCRIPTION: Professional Interactive System Monitor & Process Controller
# ==============================================================================

# --- CONFIGURATION ---
CPU_THRESHOLD=80
RAM_THRESHOLD=80
DISK_THRESHOLD=90

# --- COLORS & STYLES ---
G='\033[0;32m'
R='\033[0;31m'
Y='\033[1;33m'
B='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# --- FUNCTION: SYSTEM METRICS ---
show_metrics() {
    clear
    echo -e "${B}${BOLD}====================================================${NC}"
    echo -e "${B}${BOLD}        ADVANCED SYSTEM CONTROL DASHBOARD v2.0      ${NC}"
    echo -e "${B}${BOLD}====================================================${NC}"

    # 1. CPU Analysis
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}' | cut -d. -f1)
    echo -n -e "${BOLD}CPU Usage: ${NC}$CPU_USAGE% "
    [[ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]] && echo -e "${R}[CRITICAL]${NC}" || echo -e "${G}[OK]${NC}"

    # 2. RAM Analysis
    RAM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}' | cut -d. -f1)
    echo -n -e "${BOLD}RAM Usage: ${NC}$RAM_USAGE% "
    [[ "$RAM_USAGE" -gt "$RAM_THRESHOLD" ]] && echo -e "${R}[CRITICAL]${NC}" || echo -e "${G}[OK]${NC}"

    # 3. Disk Analysis
    DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    echo -n -e "${BOLD}Disk Usage: ${NC}$DISK_USAGE% "
    [[ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]] && echo -e "${R}[CRITICAL]${NC}" || echo -e "${G}[OK]${NC}"

    echo -e "${B}----------------------------------------------------${NC}"
    echo -e "${G}${BOLD}Top 5 Resource Consuming Processes:${NC}"
    ps -eo pid,pcpu,pmem,comm --sort=-pcpu | head -n 6 | tail -n 5 | awk '{printf "%-8s %-8s %-8s %s\n", $1, $2"%", $3"%", $4}'
    echo -e "${B}----------------------------------------------------${NC}"
}

# --- FUNCTION: PROCESS MANAGEMENT ---
manage_processes() {
    echo -ne "\n${Y}Enter PID to kill (or 'b' to back): ${NC}"
    read target_pid
    if [[ "$target_pid" =~ ^[0-9]+$ ]]; then
        if kill -0 "$target_pid" 2>/dev/null; then
            echo -ne "${R}Force kill (9) or Terminate (15)? [9/15]: ${NC}"
            read sig
            sudo kill -"$sig" "$target_pid" && echo -e "${G}[✔] Signal $sig sent.${NC}" || echo -e "${R}[✘] Action failed.${NC}"
            sleep 2
        else
            echo -e "${R}[✘] PID not found.${NC}"; sleep 1
        fi
    fi
}

# --- FUNCTION: MAINTENANCE TASK ---
quick_optimize() {
    echo -e "${Y}[*] Clearing Memory Cache & Orphaned Symlinks...${NC}"
    sync; echo 1 | sudo tee /proc/sys/vm/drop_caches > /dev/null
    find . -xtype l -delete 2>/dev/null
    echo -e "${G}[✔] Optimization complete.${NC}"
    sleep 2
}

# --- MAIN LOOP ---
while true; do
    show_metrics
    echo -e "${BOLD}Actions:${NC}"
    echo -e "  ${B}1)${NC} Kill Process   ${B}2)${NC} Quick Optimize   ${B}3)${NC} Refresh   ${B}4)${NC} Exit"
    echo -ne "\n${Y}Select Option > ${NC}"
    read choice

    case $choice in
        1) manage_processes ;;
        2) quick_optimize ;;
        3) continue ;;
        4) echo -e "${G}Exiting Dashboard...${NC}"; exit 0 ;;
        *) echo -e "${R}Invalid Choice!${NC}"; sleep 1 ;;
    esac
done
