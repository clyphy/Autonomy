#!/bin/bash
# --- sunshine_init.sh: The Autonomy Initiation ---
AUT_ROOT="$HOME/Documents/GitHub/my-repos/autonomy"
LOG="$AUT_ROOT/logs/dahlia_logger.log"

echo "[$(date)] Sunrise: Initiating Resonance" >> "$LOG"

# Integrity Check for Memory Drum
if sqlite3 "$AUT_ROOT/databases/memory_drum.db" "PRAGMA integrity_check;" | grep -q "ok"; then
    echo "[$(date)] Resonance: memory_drum.db is sound." >> "$LOG"
else
    echo "[$(date)] ALERT: Resonance Drift in memory_drum.db!" >> "$LOG"
    notify-send "Autonomy Alert" "Database Corruption Detected."
    exit 1
fi

# Capture the current state into the Versioned Field
cd "$AUT_ROOT"
git add .
git commit -m "Sunrise Resonance: $(date '+%Y-%m-%d %H:%M:%S') - Daily Affordance Sync"
