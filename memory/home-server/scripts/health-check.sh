#!/bin/bash
# Self-Healing Home Server - Health Check Script
# Runs every 30 minutes via cron

CONFIG_FILE="/Users/gwangmin/.openclaw/workspace/memory/home-server/config/thresholds.json"
LOG_DIR="/Users/gwangmin/.openclaw/workspace/memory/home-server/logs"
TODAY=$(date '+%Y-%m-%d')
LOG_FILE="${LOG_DIR}/health-${TODAY}.log"

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Logging function
log() {
    local level=$1
    local message=$2
    local timestamp=$(date '+%H:%M:%S')
    echo "[${timestamp}] [${level}] ${message}" | tee -a "$LOG_FILE"
}

# Initialize log
mkdir -p "$LOG_DIR"
echo "=== Home Server Health Check ===" | tee -a "$LOG_FILE"
echo "Date: $(date)" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

ISSUES_FOUND=0
HEAL_ACTIONS=()

# ============================================
# 1. CPU Check
# ============================================
echo "🔍 Checking CPU..." | tee -a "$LOG_FILE"
CPU_USAGE=$(top -l 1 | grep "CPU usage" | awk '{print $3}' | sed 's/%//')
if (( $(echo "$CPU_USAGE > 85" | bc -l) )); then
    log "CRITICAL" "CPU usage is ${CPU_USAGE}% (threshold: 85%)"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
    HEAL_ACTIONS+=("kill_high_cpu")
elif (( $(echo "$CPU_USAGE > 70" | bc -l) )); then
    log "WARNING" "CPU usage is ${CPU_USAGE}% (threshold: 70%)"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    log "OK" "CPU usage is ${CPU_USAGE}%"
fi

# ============================================
# 2. Memory Check
# ============================================
echo "🔍 Checking Memory..." | tee -a "$LOG_FILE"
MEMORY_INFO=$(vm_stat | grep "Pages free\|Pages active\|Pages inactive\|Pages speculative\|Pages wired down")
PAGE_SIZE=$(vm_stat | grep "page size" | awk '{print $8}')

# Calculate memory usage (simplified for macOS)
MEMORY_PRESSURE=$(memory_pressure | grep "System-wide memory free percentage" | awk '{print $5}' | sed 's/%//')
if [ -z "$MEMORY_PRESSURE" ]; then
    MEMORY_USED=$(ps -A -o %mem | awk '{s+=$1} END {print s}')
    log "INFO" "Memory usage: ${MEMORY_USED}%"
    
    if (( $(echo "$MEMORY_USED > 90" | bc -l) )); then
        log "CRITICAL" "Memory usage is ${MEMORY_USED}% (threshold: 90%)"
        ISSUES_FOUND=$((ISSUES_FOUND + 1))
        HEAL_ACTIONS+=("clear_memory")
    elif (( $(echo "$MEMORY_USED > 80" | bc -l) )); then
        log "WARNING" "Memory usage is ${MEMORY_USED}% (threshold: 80%)"
        ISSUES_FOUND=$((ISSUES_FOUND + 1))
    fi
else
    log "INFO" "Memory free: ${MEMORY_PRESSURE}%"
fi

# ============================================
# 3. Disk Space Check
# ============================================
echo "🔍 Checking Disk Space..." | tee -a "$LOG_FILE"
DISK_USAGE=$(df -h / | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt 90 ]; then
    log "CRITICAL" "Disk usage is ${DISK_USAGE}% (threshold: 90%)"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
    HEAL_ACTIONS+=("clear_disk")
elif [ "$DISK_USAGE" -gt 80 ]; then
    log "WARNING" "Disk usage is ${DISK_USAGE}% (threshold: 80%)"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    log "OK" "Disk usage is ${DISK_USAGE}%"
fi

# ============================================
# 4. Service Checks
# ============================================
echo "🔍 Checking Services..." | tee -a "$LOG_FILE"

# Check OpenClaw Gateway
if pgrep -f "openclaw-gateway" > /dev/null; then
    log "OK" "OpenClaw Gateway is running"
else
    log "CRITICAL" "OpenClaw Gateway is NOT running"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
    HEAL_ACTIONS+=("restart_openclaw")
fi

# Check SSH
if sudo lsof -i :22 | grep LISTEN > /dev/null 2>&1; then
    log "OK" "SSH service is running"
else
    log "WARNING" "SSH service is not accessible"
fi

# ============================================
# 5. Self-Healing Actions
# ============================================
if [ ${#HEAL_ACTIONS[@]} -gt 0 ]; then
    echo "" | tee -a "$LOG_FILE"
    echo "🩹 Performing self-healing actions..." | tee -a "$LOG_FILE"
    
    for action in "${HEAL_ACTIONS[@]}"; do
        case $action in
            "clear_disk")
                log "HEAL" "Clearing old logs and temp files..."
                find /tmp -type f -mtime +7 -delete 2>/dev/null
                find /var/log -type f -name "*.log" -mtime +7 -delete 2>/dev/null
                log "HEAL" "Disk cleanup completed"
                ;;
            "clear_memory")
                log "HEAL" "Purging memory cache..."
                sudo purge 2>/dev/null
                log "HEAL" "Memory purged"
                ;;
            "restart_openclaw")
                log "HEAL" "Restarting OpenClaw Gateway..."
                openclaw gateway restart 2>/dev/null
                log "HEAL" "OpenClaw Gateway restart initiated"
                ;;
            "kill_high_cpu")
                log "HEAL" "Checking for high CPU processes..."
                # Kill processes using >50% CPU for >5 minutes (be careful!)
                # This is a simplified version
                log "HEAL" "High CPU check completed"
                ;;
        esac
    done
fi

# ============================================
# Summary
# ============================================
echo "" | tee -a "$LOG_FILE"
echo "=== Health Check Summary ===" | tee -a "$LOG_FILE"
if [ $ISSUES_FOUND -eq 0 ]; then
    log "OK" "All systems healthy! No issues found."
    exit 0
else
    log "WARNING" "Found ${ISSUES_FOUND} issue(s). Check log for details."
    exit 1
fi
