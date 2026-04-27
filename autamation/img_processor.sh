#!/bin/bash

# --- CONFIGURATION ---
INPUT_DIR="./photos"
OUTPUT_DIR="./optimized_photos"
QUALITY=80
CONVERT_TO="webp" # Modern and lightweight format

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Image Optimization Tool ===${NC}"

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "Error: ImageMagick is not installed. Run: sudo pacman -S imagemagick"
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

# Count images
IMG_COUNT=$(ls "$INPUT_DIR"/*.{jpg,jpeg,png} 2>/dev/null | wc -l)

if [ "$IMG_COUNT" -eq 0 ]; then
    echo -e "${YELLOW}No images found in $INPUT_DIR.${NC}"
    exit 0
fi

echo -e "${YELLOW}[*] Found $IMG_COUNT images. Starting processing...${NC}"

# Loop through images
for img in "$INPUT_DIR"/*.{jpg,jpeg,png}; do
    [ -e "$img" ] || continue # Handle empty glob
    
    FILENAME=$(basename "$img" | cut -d. -f1)
    echo -e "${GREEN}[+] Processing: $FILENAME...${NC}"
    
    # Resize to max 1920px width (maintaining aspect ratio) and convert
    convert "$img" -resize 1920x\> -quality "$QUALITY" "$OUTPUT_DIR/${FILENAME}.${CONVERT_TO}"
done

echo -e "${BLUE}=== Done! Optimized images are in: $OUTPUT_DIR ===${NC}"
ls -lh "$OUTPUT_DIR"
