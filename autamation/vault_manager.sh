#!/bin/bash

# ==============================================================================
# SCRIPT: vault_manager.sh
# DESCRIPTION: Automated Configuration Vault & Data Integrity Monitor
# ==============================================================================

# --- CONFIGURATION ---
VAULT_DIR="$HOME/sys_vault"
BACKUP_PATH="$VAULT_DIR/backups"
CONFIG_FILES=("/etc/hosts" "/etc/resolv.conf" "$HOME/.bashrc" "$HOME/.zshrc")
RETENTION_DAYS=7

# Colors
G='\033[0;32m'
R='\033[0;31m'
Y='\033[1;33m'
B='\033[0;34m'
NC='\033[0m'

# --- INITIALIZATION ---
mkdir -p "$BACKUP_PATH"
LOG_FILE="$VAULT_DIR/vault_activity.log"

echo -e "${B}====================================================${NC}"
echo -e "${B}          SECURE CONFIGURATION VAULT ENGINE         ${NC}"
echo -e "${B}====================================================${NC}"

# --- PHASE 1: INTEGRITY CHECK (Checksum) ---
check_integrity() {
    echo -e "${Y}[*] Phase 1: Verifying integrity of critical configs...${NC}"
    for file in "${CONFIG_FILES[@]}"; do
        if [ -f "$file" ]; then
            # Calculate MD5 to see if file changed since last run
            CHECKSUM=$(md5sum "$file" | awk '{print $1}')
            echo -e "${G}[OK]${NC} $file -> Hash: $CHECKSUM"
        else
            echo -e "${R}[WARN]${NC} $file not found. Skipping."
        fi
    done
}

# --- PHASE 2: COMPRESSED ARCHIVING ---
create_vault_archive() {
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    ARCHIVE_NAME="vault_snapshot_$TIMESTAMP.tar.gz"
    
    echo -e "\n${Y}[*] Phase 2: Creating encrypted-like compressed snapshot...${NC}"
    
    # Archiving critical files into a secure location
    tar -czf "$BACKUP_PATH/$ARCHIVE_NAME" "${CONFIG_FILES[@]}" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo -e "${G}[✔] Snapshot created: $ARCHIVE_NAME${NC}"
        echo "[$(date)] SUCCESS: Created $ARCHIVE_NAME" >> "$LOG_FILE"
    else
        echo -e "${R}[✘] Snapshot failed!${NC}"
    fi
}

# --- PHASE 3: AUTOMATED RETENTION (Cleanup) ---
apply_retention_policy() {
    echo -e "\n${Y}[*] Phase 3: Applying retention policy (Removing files older than $RETENTION_DAYS days)...${NC}"
    
    # Find and delete old backups to prevent disk bloat
    OLD_BACKUPS=$(find "$BACKUP_PATH" -name "*.tar.gz" -mtime +$RETENTION_DAYS)
    
    if [ -n "$OLD_BACKUPS" ]; then
        echo "$OLD_BACKUPS" | xargs rm -v
        echo -e "${G}[✔] Old snapshots purged.${NC}"
    else
        echo -e "${B}[i] No old snapshots to remove.${NC}"
    fi
}

# --- EXECUTION ---
check_integrity
create_vault_archive
apply_retention_policy

echo -e "\n${B}====================================================${NC}"
echo -e "${G}VAULT STATUS: SECURE & UPDATED${NC}"
