#  Sentinel-Linux-Suite 🐧
> **Advanced System Hardening & Diagnostic Framework for Linux Infrastructures**

**Sentinel-Linux-Suite** is a professional-grade collection of Bash-based automation tools designed for high-concurrency environments, proactive security auditing, and deep kernel diagnostics. This suite is engineered to simplify complex SysOps and Cybersecurity tasks through a unified orchestration layer.

---

##  Deployment & Usage

To deploy the entire framework on any Linux-based environment, clone the repository and execute the **Master Command Center**:

```bash
git clone [https://github.com/ayisha-yusifzade/Linux-Sentinel-Suite.git](https://github.com/ayisha-yusifzade/Linux-Sentinel-Suite.git)
cd Linux-Sentinel-Suite
chmod +x sentinel.sh scripts/*.sh
sudo ./sentinel.sh

Framework Architecture (Module Breakdown)

The suite is divided into specialized modules, all managed via the central sentinel.sh wrapper:
1. Sentinel Command Center (sentinel.sh)

    Problem: Managing fragmented scripts during high-pressure incidents leads to delays.

    How it Works: Acts as an orchestration layer providing a unified CLI for all sub-modules.

    Security Impact: Ensures tools are executed from a verified path with proper environment checks.

2. Infrastructure Bootstrap (bootstrap_server.sh)

    Problem: Manual provisioning is prone to configuration drift and insecure defaults.

    How it Works: Automates deployment of Docker, Nginx, UFW, and Fail2Ban with production-ready hardening.

    Security Impact: Implements "Zero-Trust" firewall policies and administrative user separation.

3. Kernel & Network Tuner (kernel_tuner.sh)

    Problem: Default kernel parameters are not optimized for high-traffic or DDoS resilience.

    How it Works: Dynamically optimizes the TCP stack, window scaling, and file descriptor limits.

    Security Impact: Enhances resilience against SYN flood attacks and network stack exhaustion.

4. Sentinel Shield IDS (sentinel_shield.sh)

    Problem: Delayed awareness of brute-force attempts on remote infrastructure.

    How it Works: Monitors auth.log patterns and sends real-time intrusion alerts via Telegram API.

    Security Impact: Provides immediate situational awareness for rapid incident response.

5. I/O Physician & Latency Audit (io_physician.sh)

    Problem: Identifying hidden I/O wait bottlenecks causing system "freezes."

    How it Works: Directly polls /proc/diskstats and identifies processes in Uninterruptible Sleep (D state).

    Security Impact: Detects unauthorized encryption activity or data exfiltration patterns.

6. Inode & Ghost File Hunter (inode_phantom.sh)

    Problem: "Deleted but open" files consuming storage that standard tools cannot detect.

    How it Works: Uses lsof +L1 to hunt for unlinked file descriptors holding disk space.

    Security Impact: Prevents DoS (Denial of Service) via disk space or inode exhaustion.

7. Process Tree & Zombie Reaper (process_reaper.sh)

    Problem: Zombie processes accumulating and exhausting the system's PID limit.

    How it Works: Analyzes the process tree and signals parents to properly reap terminated children.

    Security Impact: Ensures system stability and prevents "PID exhaustion" attacks.

8. Service & Port Guardian (service_guardian.sh)

    Problem: Critical services going down or unauthorized ports opening without notice.

    How it Works: Performs automated port audits and HTTP health checks on local services.

    Security Impact: Rapidly detects unauthorized backdoors or service-level outages.

9. Vault & Data Integrity Manager (vault_manager.sh)

    Problem: Silent data corruption or unauthorized modification of sensitive system files.

    How it Works: Generates and verifies cryptographic SHA-256 checksums for critical directories.

    Security Impact: Ensures the integrity of system binaries and detects file-level tampering.

10. Real-time Performance Dashboard (sys_dashboard.sh)

    Problem: Lack of a consolidated view for system health during active monitoring.

    How it Works: A customized terminal-based dashboard showing live CPU, Memory, and Network stats.

    Security Impact: Visual cues for unusual resource spikes that could indicate a breach.

11. Linux Security Management Tool (lsmf.sh)

    Problem: Routine security maintenance tasks being time-consuming and manual.

    How it Works: A modular utility for quick security checks and user permission audits.

    Security Impact: Simplifies routine security hardening and permission management.
