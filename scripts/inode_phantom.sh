#!/bin/bash
# Inode & Ghost File Diagnostic Tool
# Detects 'Deleted but Open' files and Inode exhaustion.

echo -e "\033[1;34m[*] Phase 1: Checking Inode Usage per Directory...\033[0m"
# Find directories with more than 10,000 files (Potential inode killers)
find / -xdev -type d -size +100k 2>/dev/null | while read dir; do
    count=$(ls -1q "$dir" | wc -l)
    if [ "$count" -gt 10000 ]; then
        echo -e "\033[1;31m[!] High file count in:\033[0m $dir ($count files)"
    fi
done

echo -e "\n\033[1;34m[*] Phase 2: Hunting Ghost Files (Deleted but held by processes)...\033[0m"
# Files that are deleted from disk but still consuming space because a process holds the FD
lsof +L1 | awk '{if (NR==1 || $7 > 104857600) print $0}' # Only show files > 100MB
