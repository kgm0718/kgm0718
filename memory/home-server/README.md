# Self-Healing Home Server

## Overview
Run an always-on infrastructure agent with SSH access, automated cron jobs, and self-healing capabilities across your home network.

## Features

### 🖥️ System Monitoring
- **CPU Usage** - Alert if > 80% for 5+ minutes
- **Memory Usage** - Alert if > 85%
- **Disk Space** - Alert if < 10% free
- **Temperature** - Monitor system temp (Mac mini)

### 🔧 Service Health Checks
- OpenClaw Gateway status
- Docker containers (if running)
- SSH service
- Network connectivity

### 🩹 Self-Healing Actions
- Auto-restart crashed services
- Clear logs if disk full
- Kill zombie processes
- Restart OpenClaw if unresponsive

### 📱 Notifications
- Telegram alerts for critical issues
- Daily health reports
- Weekly summary

## Directory Structure
```
home-server/
├── scripts/
│   ├── health-check.sh       # Main health check script
│   ├── heal-disk.sh          # Disk cleanup
│   ├── heal-memory.sh        # Memory cleanup
│   └── heal-services.sh      # Service restart
├── logs/
│   └── health-YYYY-MM-DD.log # Daily health logs
├── config/
│   └── thresholds.json       # Alert thresholds
└── README.md
```

## Usage

### Manual Health Check
```bash
bash ~/.openclaw/workspace/memory/home-server/scripts/health-check.sh
```

### View Health Report
```
서버 상태 어때?
홈 서버 건강 체크해줘
```

### SSH Access (for remote management)
```
SSH로 서버 접속하고 싶어
```

## Thresholds
- CPU: Warning > 70%, Critical > 85%
- Memory: Warning > 80%, Critical > 90%
- Disk: Warning < 20%, Critical < 10%
- Load Average: Warning > 4, Critical > 8

## Auto-Heal Triggers
1. **Disk Full** → Clear logs > 7 days, clear temp files
2. **Memory Pressure** → Kill high-memory processes
3. **Service Down** → Restart service via launchctl
4. **Network Down** → Reset network interface
