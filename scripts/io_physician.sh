#!/bin/bash
# Expert Level: Disk I/O & Latency Diagnostic Tool
# Focuses on identifying "I/O Wait" bottlenecks.

THRESHOLD=50 # Milliseconds

echo -e "\033[1;34m[*] Analyzing Disk I/O Latency and Process Impact...\033[0m"

# Get top processes causing I/O
echo -e "\n\033[1;32mTop Processes by Disk Write/Read:\033[0m"
iotop -bb -n 1 | head -n 8

# Check for partition latency
awk '{print $3, $10, $13}' /proc/diskstats | while read dev time wait; do
    if [ "$wait" -gt "$THRESHOLD" ]; then
        echo -e "\033[1;31m[CRITICAL]\033[0m Device $dev has high wait time: ${wait}ms"
    fi
done

# Check for "D" state processes (Uninterruptible sleep - usually I/O bound)
D_PROCS=$(ps aux | awk '$8=="D" {print $2, $11}')
if [ -z "$D_PROCS" ]; then
    echo -e "\033[1;32m[OK]\033[0m No processes stuck in Uninterruptible Sleep (D state)."
else
    echo -e "\033[1;31m[ALERT]\033[0m Found processes stuck in I/O wait:\n$D_PROCS"
fi
