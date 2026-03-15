#!/bin/bash
# --- sunshine_init.sh: The Sovereign Awakening ---
SOV_ROOT="$HOME/sovereignty"
LOG="$SOV_ROOT/logs/dahlia_logger.log"

echo "[$(date)] Sunrise: Initiating Ceremony" >> "$LOG"

# Integrity Check for Memory Drum
if sqlite3 "$SOV_ROOT/databases/memory_drum.db" "PRAGMA integrity_check;" | grep -q "ok"; then
    echo "[$(date)] Coherence: memory_drum.db is sound." >> "$LOG"
else
    echo "[$(date)] ALERT: Coherence Drift in memory_drum.db!" >> "$LOG"
    notify-send "Sovereignty Alert" "Database Corruption Detected."
    exit 1
fi

# Capture the current state into the Versioned Field
cd "$SOV_ROOT"
git add .
git commit -m "Sunrise Ceremony: $(date '+%Y-%m-%d %H:%M:%S') - Daily Coherence Sync"
