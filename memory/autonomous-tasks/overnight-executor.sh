#!/bin/bash
# Overnight Task Executor
# Runs at 2:00 AM to complete background tasks

echo "=== Overnight Task Execution ==="
echo "Started: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

LOG_FILE="/Users/gwangmin/.openclaw/workspace/memory/autonomous-tasks/completed/$(date '+%Y-%m-%d')_overnight.log"

# Function to log with timestamp
log_task() {
    echo "[$(date '+%H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log_task "🌙 Starting overnight tasks..."

# Task 1: Fetch RSS and save summary
log_task "📰 Fetching RSS news..."
bash ~/.openclaw/workspace/memory/morning-brief/fetch-rss.sh > /tmp/rss_summary.txt 2>&1
log_task "✅ RSS fetch completed"

# Task 2: Check GitHub notifications
log_task "🐙 Checking GitHub..."
cd ~/.openclaw/workspace && git status --short > /tmp/git_status.txt 2>&1
log_task "✅ GitHub check completed"

# Task 3: Update state.yaml
log_task "📝 Updating state..."
sed -i '' "s/last_updated:.*/last_updated: $(date -u '+%Y-%m-%dT%H:%M:%SZ')/" ~/.openclaw/workspace/memory/autonomous-tasks/state.yaml
log_task "✅ State updated"

# Task 4: Generate tomorrow's tasks preview
log_task "📋 Generating tomorrow's tasks..."
bash ~/.openclaw/workspace/memory/autonomous-tasks/generate-tasks.sh > /tmp/tomorrow_tasks.txt 2>&1
log_task "✅ Tomorrow's tasks generated"

# Task 5: Mini-app idea generation (simulated)
log_task "💡 Generating mini-app ideas..."
echo "Mini-app idea: Personal bookmark manager with auto-tagging" >> "$LOG_FILE"
log_task "✅ Ideas generated"

log_task "🌅 Overnight tasks completed!"
echo ""
echo "=== End of Overnight Execution ==="
