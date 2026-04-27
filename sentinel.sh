#!/bin/bash

# ==============================================================================
# SCRIPT: sentinel.sh
# DESCRIPTION: Unified Interface for the Sentinel Infrastructure & Security Suite
# VERSION: 1.0.0
# ==============================================================================

# --- COLOR DEFINITIONS ---
G='\033[0;32m'    # Success
R='\033[0;31m'    # Danger
Y='\033[1;33m'    # Warning
B='\033[0;34m'    # Primary
M='\033[0;35m'    # Secondary
C='\033[0;36m'    # Info
BOLD='\033[1m'
NC='\033[0m'      # No Color

# --- PATH CONFIGURATION ---
BASE_DIR="$(dirname "$(readlink -f "$0")")"

# --- UI: HEADER ---
display_banner() {
    clear
    echo -e "${B}${BOLD}====================================================${NC}"
    echo -e "${B}${BOLD}          SENTINEL COMMAND CENTER (SCC)             ${NC}"
    echo -e "${C}      Professional SysAdmin & Security Toolkit      ${NC}"
    echo -e "${B}${BOLD}====================================================${NC}"
    echo -e "${Y}Node:${NC} $(hostname) | ${Y}User:${NC} $(whoami) | ${Y}Status:${NC} Ready"
    echo -e "----------------------------------------------------"
}

# --- LOGIC: EXECUTION HANDLER ---
execute_module() {
    local script="$1"
    local path="$BASE_DIR/$script"

    if [[ -f "$path" ]]; then
        echo -e "${G}[*] Initializing $script...${NC}"
        chmod +x "$path"
        bash "$path"
        echo -e "\n${Y}Module execution finished. Returning to Master Menu...${NC}"
        sleep 2
    else
        echo -e "${R}[✘] Module Error: '$script' not found in root directory.${NC}"
        sleep 2
    fi
}

# --- MAIN INTERFACE LOOP ---
while true; do
    display_banner
    echo -e "${BOLD}1. DEPLOYMENT & HARDENING${NC}"
    echo -e "  [1] Bootstrap Server Infrastructure ${C}(bootstrap_server.sh)${NC}"
    echo -e "  [2] Kernel & TCP Network Optimizer  ${C}(kernel_tuner.sh)${NC}"
    
    echo -e "\n${BOLD}2. SECURITY & AUDITING${NC}"
    echo -e "  [3] Sentinel Shield (IDS & Alert)   ${C}(sentinel_shield.sh)${NC}"
    echo -e "  [4] Network Port & Service Guardian ${C}(service_guardian.sh)${NC}"
    echo -e "  [5] Omni-Admin Security Framework   ${C}(omni_framework.sh)${NC}"

    echo -e "\n${BOLD}3. ADVANCED DIAGNOSTICS${NC}"
    echo -e "  [6] I/O Latency Physician           ${C}(io_physician.sh)${NC}"
    echo -e "  [7] Inode & Ghost File Analyzer     ${C}(inode_phantom.sh)${NC}"
    echo -e "  [8] Process Tree & Zombie Reaper    ${C}(process_reaper.sh)${NC}"

    echo -e "\n${BOLD}4. SYSTEM MAINTENANCE${NC}"
    echo -e "  [9] Vault & Data Integrity Manager  ${C}(vault_manager.sh)${NC}"
    echo -e "  [0] Real-time Performance Dashboard ${C}(sys_dashboard_pro.sh)${NC}"
    
    echo -e "\n${R}[q] Terminate Sentinel Session${NC}"
    echo -e "----------------------------------------------------"
    
    echo -ne "${BOLD}${Y}Sentinel-Command > ${NC}"
    read -r choice

    case $choice in
        1) execute_module "bootstrap_server.sh" ;;
        2) execute_module "kernel_tuner.sh" ;;
        3) execute_module "sentinel_shield.sh" ;;
        4) execute_module "service_guardian.sh" ;;
        5) execute_module "omni_framework.sh" ;;
        6) execute_module "io_physician.sh" ;;
        7) execute_module "inode_phantom.sh" ;;
        8) execute_module "process_reaper.sh" ;;
        9) execute_module "vault_manager.sh" ;;
        0) execute_module "sys_dashboard_pro.sh" ;;
        q|Q) echo -e "${G}Shutting down. System secured.${NC}"; exit 0 ;;
        *) echo -e "${R}Invalid Input. Please select a valid module (1-9, 0, q).${NC}"; sleep 1 ;;
    esac
done
