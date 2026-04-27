#!/bin/bash

# ==============================================================================
# SCRIPT: sys_tuner.sh
# DESCRIPTION: Interactive System Performance Monitor & Process Tuner
# AUTHOR: Aisha Yusifzade
# ==============================================================================

# --- COLORS ---
G='\033[0;32m'
R='\033[0;31m'
Y='\033[1;33m'
B='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# --- FUNCTION: SYSTEM OVERVIEW ---
show_stats() {
    clear
    echo -e "${B}${BOLD}====================================================${NC}"
    echo -e "${B}${BOLD}          SYSTEM PERFORMANCE TUNER v1.0             ${NC}"
    echo -e "${B}${BOLD}====================================================${NC}"
    
    # Capture metrics
    UPTIME=$(uptime -p)
    LOAD=$(cat /proc/loadavg | awk '{print $1, $2, $3}')
    MEM_FREE=$(free -h | awk '/Mem:/ {print $4}')
    
    echo -e "${Y}Uptime:${NC} $UPTIME"
    echo -e "${Y}Load Average:${NC} $LOAD"
    echo -e "${Y}Available RAM:${NC} $MEM_FREE"
    echo -e "----------------------------------------------------"
}

# --- FUNCTION: LIST TOP PROCESSES ---
list_top_processes() {
    echo -e "${G}${BOLD}Top 10 Processes by Resource Usage:${NC}"
    echo -e "${B}PID\t%CPU\t%MEM\tCOMMAND${NC}"
    ps -eo pid,pcpu,pmem,comm --sort=-pcpu | head -n 11 | tail -n 10
}

# --- FUNCTION: KILL PROCESS ---
manage_processes() {
    echo -e "\n${Y}Enter PID to terminate (or 'q' to go back):${NC}"
    read -p "Target PID > " target_pid
    
    if [[ "$target_pid" =~ ^[0-9]+$ ]]; then
        if kill -0 "$target_pid" 2>/dev/null; then
            kill -15 "$target_pid"
            echo -e "${G}[✔] Termination signal sent to PID $target_pid.${NC}"
            sleep 2
        else
            echo -e "${R}[✘] PID $target_pid not found.${NC}"
            sleep 2
        fi
    fi
}

# --- FUNCTION: LOG CLEANUP OPTIMIZER ---
optimize_system() {
    echo -e "${Y}[*] Running quick optimization...${NC}"
    # Cleaning memory cache (Safe way)
    sync; echo 1 | sudo tee /proc/sys/vm/drop_caches > /dev/null
    echo -e "${G}[✔] Memory cache cleared.${NC}"
    # Removing broken symbolic links
    find . -xtype l -delete
    echo -e "${G}[✔] Broken symlinks removed.${NC}"
    sleep 2
}

# --- MAIN INTERACTIVE LOOP ---
while true; do
    show_stats
    list_top_processes
    
    echo -e "\n${BOLD}Quick Actions:${NC}"
    echo -e "  ${B}1)${NC} Kill a Process"
    echo -e "  ${B}2)${NC} Run System Optimization"
    echo -e "  ${B}3)${NC} Refresh Stats"
    echo -e "  ${B}4)${NC} Exit"
    
    echo -ne "\n${Y}Selection > ${NC}"
    read choice

    case $choice in
        1) manage_processes ;;
        2) optimize_system ;;
        3) continue ;;
        4) echo -e "${G}Exiting...${NC}"; exit 0 ;;
        *) echo -e "${R}Invalid option.${NC}"; sleep 1 ;;
    esac
done
