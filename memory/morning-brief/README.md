# Custom Morning Brief System

## Overview
Every morning, receive a personalized briefing with news, tasks, weather, and AI-recommended actions.

## Schedule
- **Time:** 8:00 AM daily
- **Delivery:** Telegram
- **Days:** Monday-Sunday (configurable)

## Briefing Components

### 1. Weather ☀️
- Current temperature
- Today's forecast
- Rain/Snow alert
- Recommendation (umbrella, jacket, etc.)

### 2. Calendar 📅
- Today's events
- Tomorrow's preview
- Meeting reminders

### 3. Tasks ✅
- Overdue tasks
- Today's priorities
- Tasks from Todoist (if connected)

### 4. News 📰
- Tech news summary
- Personalized topics
- Top headlines

### 5. AI Recommendations 🤖
- Suggested actions for the day
- Follow-ups from yesterday
- Proactive reminders

## Configuration
Edit `morning-brief-config.json` to customize:
- Briefing time
- Topics of interest
- News sources
- Delivery channel

## Files
- `morning-brief-config.json` - Configuration
- `morning-brief-template.md` - Template
- `last-brief.txt` - Last briefing timestamp
