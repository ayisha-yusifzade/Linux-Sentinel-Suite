#!/bin/bash

# --- COLORS FOR TERMINAL OUTPUT ---
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

LOG_FILE="/home/$USER/system_maintenance.log"

echo -e "${GREEN}--- System Maintenance Started: $(date) ---${NC}" | tee -a "$LOG_FILE"

# 1. System Update (Optimized for Arch-based systems like CachyOS)
echo -e "\n${GREEN}[+] Synchronizing and updating system packages...${NC}"
sudo pacman -Syu --noconfirm | tee -a "$LOG_FILE"

# 2. Orphaned Package Cleanup
# (Finding packages that were installed as dependencies but are no longer needed)
echo -e "\n${GREEN}[+] Checking for orphaned packages...${NC}"
ORPHANS=$(pacman -Qdtq)

if [[ -n "$ORPHANS" ]]; then
    echo "Removing orphaned packages: $ORPHANS" | tee -a "$LOG_FILE"
    sudo pacman -Rs $ORPHANS --noconfirm | tee -a "$LOG_FILE"
else
    echo "No orphaned packages found to remove." | tee -a "$LOG_FILE"
fi

# 3. Package Cache Cleanup
# (Clears the local cache of downloaded packages to free up disk space)
echo -e "\n${GREEN}[+] Clearing package cache...${NC}"
sudo pacman -Scc --noconfirm | tee -a "$LOG_FILE"

# 4. Final Status Check
if [ ${PIPESTATUS[0]} -eq 0 ]; then
    echo -e "\n${GREEN}✔ System maintenance completed successfully!${NC}" | tee -a "$LOG_FILE"
else
    echo -e "\n${RED}✘ An error occurred during the system update.${NC}" | tee -a "$LOG_FILE"
fi

echo -e "${GREEN}-------------------------------------------${NC}\n" | tee -a "$LOG_FILE"
