#!/bin/bash

# --- CONFIGURATION ---
SOURCE_DIR="/home/$USER/source_folder"
BACKUP_DIR="/home/$USER/backups"
DATE=$(date +%Y-%m-%d_%H-%M)
BACKUP_NAME="backup_$DATE.tar.gz"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# --- BACKUP PROCESS ---
echo "Starting backup of: $SOURCE_DIR"

# Compressing the source folder
tar -czf "$BACKUP_DIR/$BACKUP_NAME" "$SOURCE_DIR" 2>/dev/null

# Checking if the backup command was successful
if [ $? -eq 0 ]; then
    echo "Backup created successfully: $BACKUP_NAME"
else
    echo "Error: Backup failed!"
    exit 1
fi

# --- SMART CLEANUP ---
# Delete backups older than 7 days to save space
echo "Cleaning up old backups..."
find "$BACKUP_DIR" -type f -name "backup_*.tar.gz" -mtime +7 -exec rm {} \;

echo "Operation completed."
