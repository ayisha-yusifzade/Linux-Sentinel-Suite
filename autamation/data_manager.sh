#!/bin/bash

# --- CONFIGURATION ---
# Set the directory you want to clean up
TARGET_DIR="./test_folder"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Starting File Organization in: $TARGET_DIR${NC}"

# Create target directory if it doesn't exist
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR" || exit

# --- ORGANIZATION LOGIC ---

# Create folders for different file types
mkdir -p Images Documents Scripts Arcs Others

echo -e "${YELLOW}Moving files to their respective folders...${NC}"

# Move Images
mv *.jpg *.jpeg *.png *.gif *.svg Images/ 2>/dev/null

# Move Documents
mv *.pdf *.doc *.docx *.txt *.md Documents/ 2>/dev/null

# Move Scripts
mv *.sh *.py *.js *.cpp Scripts/ 2>/dev/null

# Move Archives
mv *.zip *.tar *.gz *.rar Arcs/ 2>/dev/null

# Move everything else (that is a file, not a folder)
find . -maxdepth 1 -type f -exec mv {} Others/ \; 2>/dev/null

# --- CLEANUP & SUMMARY ---
# Remove empty folders
find . -type d -empty -delete

echo -e "${GREEN}Organization complete!${NC}"
ls -R
