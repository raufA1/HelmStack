#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-}"; DIR="${2:-workspace/research}"; PLANS_DIR="${3:-workspace/plans}"; MEM_DIR="${4:-memory}"
mkdir -p "$DIR"
case "$CMD" in
  ask)  TOPIC="${3:-${TOPIC:-}}"; [ -n "$TOPIC" ] || { echo "TOPIC required"; exit 1; }
        TS="$(date '+%Y%m%d-%H%M%S')"; THREAD="$DIR/$TS"; mkdir -p "$THREAD"
        printf "# Proposal: %s\n\n## Notes\n- \n" "$TOPIC" > "$THREAD/proposal.md"
        echo "Created: $THREAD";;
  check)LAST="$(ls -dt "$DIR"/* 2>/dev/null | head -n1 || true)"; [ -n "$LAST" ] || { echo "No threads"; exit 0; }
        sed -n '1,120p' "$LAST/proposal.md" || true;;
  yes)  LAST="$(ls -dt "$DIR"/* 2>/dev/null | head -n1 || true)"; [ -n "$LAST" ] || { echo "No threads"; exit 0; }
        echo "- $(date '+%Y-%m-%d %H:%M') APPROVED: $(basename "$LAST")" >> "$MEM_DIR/DECISIONS.md"
        echo "- [ ] Implement approved proposal: $(basename "$LAST")" >> "$PLANS_DIR/NEXT_STEPS.md"
        echo "Approved.";;
  no)   LAST="$(ls -dt "$DIR"/* 2>/dev/null | head -n1 || true)"; [ -n "$LAST" ] || { echo "No threads"; exit 0; }
        echo "- $(date '+%Y-%m-%d %H:%M') CHANGES REQUESTED: $(basename "$LAST")" >> "$MEM_DIR/DECISIONS.md"
        echo "Changes requested.";;
  end)  LAST="$(ls -dt "$DIR"/* 2>/dev/null | head -n1 || true)"; [ -n "$LAST" ] || { echo "No threads"; exit 0; }
        mv "$LAST" "${DIR}/archive_$(basename "$LAST")"; echo "Finalized.";;
  *)    echo "Usage: research.sh [ask|check|yes|no|end]";;
esac