#  Sentinel-Linux-Suite 🐧
> **System Hardening & Diagnostic Framework for Linux Infrastructures**

**Sentinel-Linux-Suite** is a professional-grade collection of Bash-based automation tools designed for high-concurrency environments, proactive security auditing, and deep kernel diagnostics.

---

##  Deployment & Usage

To deploy the entire framework on any Linux-based environment, clone the repository and execute the **Master Command Center**:

```bash
git clone [https://github.com/ayisha-yusifzade/Linux-Sentinel-Suite.git](https://github.com/ayisha-yusifzade/Linux-Sentinel-Suite.git)
cd Linux-Sentinel-Suite
chmod +x sentinel.sh scripts/*.sh
sudo ./sentinel.sh
```
## Framework Architecture (Module Breakdown)

The suite is architected as a modular framework, where each specialized component addresses a specific infrastructure or security challenge. All modules are orchestrated via the central entry point to ensure execution integrity.

---

### Core Components

**1. Sentinel Orchestrator (`sentinel.sh`)**
* **Problem:** Managing fragmented scripts during high-pressure incidents leads to operational delays.
* **Solution:** Acts as a centralized orchestration layer providing a unified CLI for all sub-modules.
* **Security Impact:** Ensures tools are executed from a verified path with strict environment checks.

**2. Infrastructure Bootstrap (`bootstrap_server.sh`)**
* **Problem:** Manual provisioning is prone to configuration drift and insecure default settings.
* **Solution:** Automates the deployment of Nginx, Docker, and UFW with pre-hardened configurations.
* **Security Impact:** Implements "Zero-Trust" firewall policies and administrative privilege separation.

**3. I/O Physician (`io_physician.sh`)**
* **Focus:** Storage Latency & Forensics.
* **Problem:** Identifying hidden I/O wait bottlenecks that cause system-wide instability.
* **Solution:** Directly polls `/proc/diskstats` to isolate processes in Uninterruptible Sleep (D state).
* **Security Impact:** Detects unauthorized encryption activity (Ransomware) or unusual data exfiltration patterns.

**4. Inode & Ghost Hunter (`inode_phantom.sh`)**
* **Problem:** "Deleted but open" files consuming storage that standard tools like `du` cannot detect.
* **Solution:** Utilizes `lsof +L1` auditing to identify and recover "ghost" disk space.
* **Security Impact:** Prevents Denial of Service (DoS) attacks targeting storage or inode exhaustion.

**5. Kernel & Network Tuner (`kernel_tuner.sh`)**
* **Problem:** Default kernel parameters are not optimized for high-traffic or DDoS resilience.
* **Solution:** Dynamically adjusts `sysctl` parameters to optimize the TCP stack and window scaling.
* **Security Impact:** Enhances system resilience against SYN flood and network stack exhaustion attacks.

**6. Process Tree Reaper (`process_reaper.sh`)**
* **Problem:** Zombie and orphaned processes accumulating and exhausting the system's PID limit.
* **Solution:** Analyzes the process tree and signals parents to properly reap terminated children.
* **Security Impact:** Ensures system stability and prevents PID exhaustion-based attacks.

**7. Service & Port Guardian (`service_guardian.sh`)**
* **Problem:** Unauthorized ports opening or critical services failing without immediate detection.
* **Solution:** Performs automated port audits and HTTP health checks on local services.
* **Security Impact:** Rapidly identifies unauthorized backdoors or service-level outages.

**8. Vault Integrity Manager (`vault_manager.sh`)**
* **Problem:** Silent data corruption or unauthorized modification of sensitive system binaries.
* **Solution:** Implements SHA-256 cryptographic checksum verification for critical directories.
* **Security Impact:** Provides host-based intrusion detection by alerting on file-level tampering.

**9. Real-time Dashboard (`sys_dashboard.sh`)**
* **Problem:** Lack of a consolidated visual overview for system health during active monitoring.
* **Solution:** A terminal-based dashboard providing live telemetry on CPU, Memory, and Network.
* **Security Impact:** Offers visual cues for anomalous resource spikes that may indicate a breach.

**10. Security Management Framework (`lsmf.sh`)**
* **Problem:** Routine security maintenance and permission audits are time-consuming and manual.
* **Solution:** A modular utility designed for rapid security hardening and user audit tasks.
* **Security Impact:** Simplifies the enforcement of consistent security policies across diverse environments.

---
