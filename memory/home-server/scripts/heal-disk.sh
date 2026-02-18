#!/bin/bash
# Heal Disk - Clear space when disk is full

LOG_FILE="/Users/gwangmin/.openclaw/workspace/memory/home-server/logs/heal-disk-$(date '+%Y-%m-%d').log"

echo "$(date) - Starting disk healing..." | tee -a "$LOG_FILE"

# Clear system caches
sudo rm -rf /System/Library/Caches/* 2>/dev/null

# Clear user caches
rm -rf ~/Library/Caches/* 2>/dev/null

# Clear temp files older than 3 days
find /tmp -type f -mtime +3 -delete 2>/dev/null
find /var/tmp -type f -mtime +3 -delete 2>/dev/null

# Clear old logs
find /var/log -type f -name "*.log" -mtime +3 -exec rm -f {} \; 2>/dev/null

# Clear OpenClaw logs older than 7 days
find /tmp/openclaw -type f -mtime +7 -delete 2>/dev/null

# Empty trash
rm -rf ~/.Trash/* 2>/dev/null

echo "$(date) - Disk healing completed" | tee -a "$LOG_FILE"

# Check disk space after cleanup
DF_AFTER=$(df -h / | tail -1 | awk '{print $5}')
echo "Disk usage after cleanup: ${DF_AFTER}" | tee -a "$LOG_FILE"
