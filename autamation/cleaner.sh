#!/bin/bash

# --- CONFIGURATION ---
REPORT_FILE="system_report.html"
HOSTNAME=$(hostname)
DATE=$(date "+%Y-%m-%d %H:%M:%S")

# Thresholds
DISK_CRITICAL=90
RAM_CRITICAL=85

# --- HTML HEADER ---
cat <<EOF > $REPORT_FILE
<html>
<head>
    <title>System Health Report - $HOSTNAME</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; padding: 20px; }
        .header { background: #333; color: white; padding: 10px; text-align: center; border-radius: 5px; }
        .section { background: white; margin: 15px 0; padding: 15px; border-radius: 5px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .critical { color: red; font-weight: bold; }
        .ok { color: green; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }
    </style>
</head>
<body>
    <div class="header">
        <h1>System Health Report: $HOSTNAME</h1>
        <p>Generated on: $DATE</p>
    </div>
EOF

# --- 1. DISK USAGE ---
DISK_VAL=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
DISK_STATUS="<span class='ok'>OK</span>"
[[ $DISK_VAL -gt $DISK_CRITICAL ]] && DISK_STATUS="<span class='critical'>CRITICAL</span>"

cat <<EOF >> $REPORT_FILE
    <div class="section">
        <h2>💾 Disk Usage (Root)</h2>
        <p>Usage: <strong>$DISK_VAL%</strong> | Status: $DISK_STATUS</p>
    </div>
EOF

# --- 2. RAM USAGE ---
RAM_VAL=$(free | grep Mem | awk '{print $3/$2 * 100.0}' | cut -d. -f1)
RAM_STATUS="<span class='ok'>OK</span>"
[[ $RAM_VAL -gt $RAM_CRITICAL ]] && RAM_STATUS="<span class='critical'>CRITICAL</span>"

cat <<EOF >> $REPORT_FILE
    <div class="section">
        <h2>🧠 Memory (RAM)</h2>
        <p>Usage: <strong>$RAM_VAL%</strong> | Status: $RAM_STATUS</p>
    </div>
EOF

# --- 3. ACTIVE SERVICES ---
# Check if key services are running (e.g., NetworkManager, Docker, etc.)
SERVICE="NetworkManager"
if systemctl is-active --quiet $SERVICE; then
    S_STATUS="<span class='ok'>Running</span>"
else
    S_STATUS="<span class='critical'>Stopped</span>"
fi

cat <<EOF >> $REPORT_FILE
    <div class="section">
        <h2>⚙️ Critical Services</h2>
        <table>
            <tr><th>Service</th><th>Status</th></tr>
            <tr><td>$SERVICE</td><td>$S_STATUS</td></tr>
        </table>
    </div>
EOF

# --- HTML FOOTER ---
cat <<EOF >> $REPORT_FILE
    <div style="text-align: center; margin-top: 20px; color: #777;">
        <p>End of System Audit</p>
    </div>
</body>
</html>
EOF

echo "Success: Report generated at $REPORT_FILE"
# Optional: Open the report automatically in a browser
# xdg-open $REPORT_FILE
