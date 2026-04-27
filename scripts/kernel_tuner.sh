#!/bin/bash
# Expert Level: Kernel & TCP Networking Tuner
# Purpose: Optimize system for high-concurrency workloads.

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

echo -e "\033[1;35m[*] Tuning Linux Kernel for High Performance...\033[0m"

# 1. Increase max open files
sysctl -w fs.file-max=2097152

# 2. Optimize TCP connection reuse (Better for web servers)
sysctl -w net.ipv4.tcp_tw_reuse=1
sysctl -w net.ipv4.ip_local_port_range="1024 65535"

# 3. Increase TCP buffer sizes for faster networking
sysctl -w net.core.rmem_max=16777216
sysctl -w net.core.wmem_max=16777216

echo -e "\033[1;32m[✔] Kernel networking stack optimized.\033[0m"
