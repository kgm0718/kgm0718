#!/bin/bash
# Heal Services - Restart failed services

LOG_FILE="/Users/gwangmin/.openclaw/workspace/memory/home-server/logs/heal-services-$(date '+%Y-%m-%d').log"

echo "$(date) - Starting service healing..." | tee -a "$LOG_FILE"

# Check and restart OpenClaw
if ! pgrep -f "openclaw-gateway" > /dev/null; then
    echo "OpenClaw Gateway not running, restarting..." | tee -a "$LOG_FILE"
    openclaw gateway restart 2>/dev/null
    echo "OpenClaw Gateway restart initiated" | tee -a "$LOG_FILE"
fi

# Check and restart SSH (if not running)
if ! sudo lsof -i :22 | grep LISTEN > /dev/null 2>&1; then
    echo "SSH not accessible, checking..." | tee -a "$LOG_FILE"
    sudo launchctl load /System/Library/LaunchDaemons/ssh.plist 2>/dev/null
fi

echo "$(date) - Service healing completed" | tee -a "$LOG_FILE"
