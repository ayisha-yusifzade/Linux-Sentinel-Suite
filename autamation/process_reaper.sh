#!/bin/bash
# Expert Level: Advanced Process Tree Analyzer
# Focuses on cleaning orphaned and zombie processes.

echo -e "\033[1;36m[*] Scanning for Zombie and Orphaned Processes...\033[0m"

# Find Zombies
ZOMBIES=$(ps -ef | awk '$2 == "Z" {print $2}')

if [ -n "$ZOMBIES" ]; then
    echo -e "\033[1;31m[!] Found Zombie PIDs:\033[0m $ZOMBIES"
    for pid in $ZOMBIES; do
        PPID=$(ps -o ppid= -p "$pid")
        echo "Zombie $pid belongs to Parent $PPID. Signaling parent..."
        kill -CHLD "$PPID"
    done
else
    echo -e "\033[1;32m[✔] No zombies detected.\033[0m"
fi

# Find Orphans (PPID 1 but not system daemons)
echo -e "\n\033[1;34m[*] Identifying potential orphan processes...\033[0m"
ps -elf | awk '$5 == 1 && $3 != "root" {print "Potential Orphan: " $4 " (" $15 ")"}'
