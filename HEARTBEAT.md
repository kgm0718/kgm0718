# HEARTBEAT.md - Rotating Check System

## Cadence-Based Checks

Read `heartbeat-state.json`. Run whichever check is most overdue.

**Cadences:**
- Email: every 30 min (9 AM - 9 PM only)
- Calendar: every 2 hours (8 AM - 10 PM only)
- Tasks: every 30 min (anytime)
- Git: every 24 hours (anytime)
- System: every 24 hours (3 AM only)

**Process:**
1. Load timestamps from heartbeat-state.json
2. Calculate which check is most overdue (respect time windows)
3. Run that check
4. Update timestamp
5. Report if actionable, otherwise HEARTBEAT_OK

---

## Email Check

Check for new messages from authorized senders.

**Report ONLY if:**
- New email from authorized sender
- Contains actionable request

**Update:** email timestamp in state file

---

## Calendar Check

Check for upcoming events in next 24-48h.

**Report ONLY if:**
- Event starting in < 2 hours
- Event requires preparation

**Update:** calendar timestamp in state file

---

## Tasks Check

Check for stalled or blocked work.

**Report ONLY if:**
- Task blocked > 24 hours
- Task assigned to user

**Update:** tasks timestamp in state file

---

## Git Check

Check workspace for uncommitted changes.

**Report ONLY if:**
- Uncommitted changes > 24 hours
- Unpushed commits exist

**Update:** git timestamp in state file

---

## System Check

Check for failed cron jobs and error logs.

**Report ONLY if:**
- Failed cron job found
- Error log entries detected

**Update:** system timestamp in state file
