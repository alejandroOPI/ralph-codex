#!/bin/bash
# Ralph for Codex - Simple version
# Based on Geoff Huntley's original Ralph technique
# "Dumb things can work surprisingly well"

set -e

PROMPT_FILE="${PROMPT_FILE:-PROMPT.md}"
MAX_LOOPS="${MAX_LOOPS:-100}"
TIMEOUT_MINS="${TIMEOUT_MINS:-30}"
WORKDIR="${WORKDIR:-.}"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() { echo -e "${GREEN}[$(date '+%H:%M:%S')]${NC} $1"; }
warn() { echo -e "${YELLOW}[$(date '+%H:%M:%S')]${NC} $1"; }
err() { echo -e "${RED}[$(date '+%H:%M:%S')]${NC} $1"; }

# Parse args
while [[ $# -gt 0 ]]; do
  case $1 in
    -t|--timeout) TIMEOUT_MINS="$2"; shift 2 ;;
    -l|--loops) MAX_LOOPS="$2"; shift 2 ;;
    -p|--prompt) PROMPT_FILE="$2"; shift 2 ;;
    -h|--help)
      echo "Usage: codex-ralph [OPTIONS]"
      echo "  -t, --timeout MINS   Timeout per loop (default: 30)"
      echo "  -l, --loops NUM      Max loops (default: 100)"
      echo "  -p, --prompt FILE    Prompt file (default: PROMPT.md)"
      exit 0 ;;
    *) shift ;;
  esac
done

cd "$WORKDIR"
mkdir -p logs

if [[ ! -f "$PROMPT_FILE" ]]; then
  err "No $PROMPT_FILE found. Create one first!"
  exit 1
fi

log "🚀 Ralph starting"
log "   Prompt: $PROMPT_FILE"
log "   Timeout: ${TIMEOUT_MINS}m per loop"
log "   Max loops: $MAX_LOOPS"
echo ""

for i in $(seq 1 $MAX_LOOPS); do
  LOGFILE="logs/loop_${i}_$(date +%Y%m%d_%H%M%S).log"
  
  log "━━━ Loop $i/$MAX_LOOPS ━━━"
  
  # Run Codex with timeout
  if command -v gtimeout &>/dev/null; then
    TIMEOUT_CMD="gtimeout"
  else
    TIMEOUT_CMD="timeout"
  fi
  
  $TIMEOUT_CMD ${TIMEOUT_MINS}m codex exec --skip-git-repo-check --full-auto \
    "$(cat $PROMPT_FILE)" 2>&1 | tee "$LOGFILE"
  
  EXIT_CODE=${PIPESTATUS[0]}
  
  # Check for completion signal
  if grep -q "RALPH_DONE" "$LOGFILE" 2>/dev/null; then
    log "✅ RALPH_DONE - Project complete!"
    break
  fi
  
  # Check for stuck signal
  if grep -q "RALPH_STUCK" "$LOGFILE" 2>/dev/null; then
    warn "⚠️  RALPH_STUCK detected"
    grep "RALPH_STUCK" "$LOGFILE"
    break
  fi
  
  # Timeout
  if [[ $EXIT_CODE -eq 124 ]]; then
    warn "⏰ Loop $i timed out after ${TIMEOUT_MINS}m"
  fi
  
  # Brief pause
  sleep 3
done

log "🏁 Ralph finished after $i loops"
log "   Logs in: logs/"
