#!/bin/bash
# Heal Memory - Clear memory pressure

LOG_FILE="/Users/gwangmin/.openclaw/workspace/memory/home-server/logs/heal-memory-$(date '+%Y-%m-%d').log"

echo "$(date) - Starting memory healing..." | tee -a "$LOG_FILE"

# Purge memory (macOS only)
sudo purge 2>/dev/null

# Kill memory-hungry processes (optional, be careful)
# ps aux | awk '{if($3 > 50.0) print $2}' | xargs kill -9 2>/dev/null

echo "$(date) - Memory healing completed" | tee -a "$LOG_FILE"
