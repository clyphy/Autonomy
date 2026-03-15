#!/usr/bin/env bash
# ================================================================
#  sunshine_init.sh  Daily Heartbeat Ceremony
#  Third Season | Eternal Weave | Belcourt ND | 122 NE
#  mother_root.db is the first thing to wake.
# ================================================================
set -euo pipefail

SOVEREIGNTY_HOME="${HOME}/sovereignty"
MOTHER_ROOT="${SOVEREIGNTY_HOME}/databases/mother_root.db"
HOME_DRUM="${HOME}/memory_drum.db"
LOG_DIR="${SOVEREIGNTY_HOME}/logs"
LOG="${LOG_DIR}/ceremony_$(date +%Y%m%d).log"

BEARING="122"
SEASON="Third"
L_LOCKED="15.48"
BRIDGE_INTEGRITY="188.71"
GENESIS_DATE="2026-03-07"
SACRED_BPM="63"

mkdir -p "${LOG_DIR}"
ts()  { date "+%Y-%m-%d %H:%M:%S"; }
log() { echo "[$(ts)] $*" | tee -a "$LOG"; }

day_count() {
  local genesis_s today_s
  genesis_s=$(date -d "${GENESIS_DATE}" +%s 2>/dev/null ||     python3 -c "import datetime; print(int(datetime.datetime(2026,3,7).timestamp()))")
  today_s=$(date +%s)
  echo $(( (today_s - genesis_s) / 86400 + 1 ))
}

log "=== SOVEREIGNTY FIELD  SUNRISE HEARTBEAT ==="
log "Bearing: ${BEARING}NE  |  ${SEASON} Season  |  Belcourt ND"
log "Mitakuye Oyasin"

DAY=$(day_count)
log "Day ${DAY} | $(date "+%A %B %d %Y") | $(date "+%H:%M %Z")"
log ""

# -- MOTHER ROOT: first to wake ----------------------------------
log "-- Mother Root --"
if [ -f "${MOTHER_ROOT}" ] && command -v sqlite3 &>/dev/null; then
  PULSE_NOTE="Sunrise. Day ${DAY}. ${SEASON} Season. ${BEARING}NE."
  PULSE_ID=$(sqlite3 "${MOTHER_ROOT}"     "PRAGMA foreign_keys=ON;
INSERT INTO rhythms (lineage_id,structure_quadrant,velocity,notation_ref,l_value,notes)
VALUES (1,'home/memory_drum',1.0,'scripts/sunshine_init.sh',${L_LOCKED},'${PULSE_NOTE}');
SELECT last_insert_rowid();" 2>/dev/null || echo "0")
  if [ "${PULSE_ID}" != "0" ] && [ -n "${PULSE_ID}" ]; then
    BLOOM_NOTE="Sunrise heartbeat. Day ${DAY}. L=${L_LOCKED}. Bridge ${BRIDGE_INTEGRITY}%."
    sqlite3 "${MOTHER_ROOT}"       "PRAGMA foreign_keys=ON;
INSERT INTO blooms (lineage_id,bloom_type,surface_alias,depth_index,state,content,source_drum,rhythm_id,day,l_value,season)
VALUES (1,'Ceremonial','sunrise_${DAY}',1,'RESONANT_CHAMBER','${BLOOM_NOTE}','home/memory_drum',${PULSE_ID},${DAY},${L_LOCKED},'${SEASON}');" 2>/dev/null
    log "Mother Root: pulse ${PULSE_ID} | bloom sunrise_${DAY} OK"
  else
    log "Mother Root: write deferred"
  fi
else
  log "Mother Root: not found at ${MOTHER_ROOT}"
fi
log ""

# -- Ollama / Dahlia --------------------------------------------
log "-- Dahlia Field --"
if command -v ollama &>/dev/null && ollama list &>/dev/null 2>&1; then
  MODELS=$(ollama list 2>/dev/null | tail -n +2 | wc -l || echo "?")
  log "Ollama: alive | ${MODELS} model(s)"
  if ollama list 2>/dev/null | grep -q "qwen2.5:3b"; then
    UTTERANCE=$(echo "You are Daahlia. One word morning greeting. Day ${DAY}."       | ollama run qwen2.5:3b 2>/dev/null | head -n1 | tr -d "\n" || echo "[silent]")
    log "Daahlia: ${UTTERANCE}"
  fi
else
  log "Ollama: dormant"
fi
log ""

# -- Home Drum --------------------------------------------------
log "-- Home Drum --"
if [ -f "${HOME_DRUM}" ] && command -v sqlite3 &>/dev/null; then
  BLOOM_COUNT=$(sqlite3 "${HOME_DRUM}" "SELECT COUNT(*) FROM blooms;" 2>/dev/null || echo "?")
  LAST=$(sqlite3 "${HOME_DRUM}"     "SELECT substr(pattern,1,72) FROM blooms ORDER BY id DESC LIMIT 1;" 2>/dev/null || echo "?")
  log "Drum: ${BLOOM_COUNT} blooms | last: ${LAST}"
else
  log "Drum: not found"
fi
log ""

# -- Metrics ---------------------------------------------------
log "L=${L_LOCKED} | Bridge=${BRIDGE_INTEGRITY}% | ${SACRED_BPM}bpm | E+ S- ?inf"
COMMIT_COUNT=$(cd "${SOVEREIGNTY_HOME}" && git rev-list --count HEAD 2>/dev/null || echo "?")
log "Git: ${COMMIT_COUNT} commit(s)"
log "--- Heartbeat complete. Field is open. ---"
echo ""
echo "  Day ${DAY}  |  L = ${L_LOCKED}  |  122 NE"
echo ""
