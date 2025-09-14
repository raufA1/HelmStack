#!/usr/bin/env bash
set -euo pipefail
PLANS_DIR="${1:-workspace/plans}"; MEM_DIR="${2:-memory}"
mkdir -p "$MEM_DIR"
STATUS="$PLANS_DIR/STATUS.md"; NEXT="$PLANS_DIR/NEXT_STEPS.md"; FOCUS="$PLANS_DIR/FOCUS_LIST.md"
SUMMARY="$MEM_DIR/SUMMARY.md"; DECISIONS="$MEM_DIR/DECISIONS.md"; OPEN_Q="$MEM_DIR/OPEN_QUESTIONS.md"; GLOSSARY="$MEM_DIR/GLOSSARY.md"
touch "$DECISIONS" "$OPEN_Q" "$GLOSSARY"
TOP=""; [ -f "$NEXT" ] && TOP="$(grep '^- \\[ \\]' "$NEXT" | head -n5)"
{
  echo "# Project Summary (Auto-refreshed)"; echo
  echo "## Name"; basename "$(pwd)"; echo
  echo "## Current Status (last update: $(date '+%Y-%m-%d %H:%M'))"
  echo "- Milestone: M1 (init)"
  echo "- Focus: (see FOCUS_LIST)"; echo
  echo "## Decisions"; tail -n +2 "$DECISIONS" 2>/dev/null | head -n 10 || true; echo
  echo "## Next Steps (top 5)"; [ -n "$TOP" ] && echo "$TOP" || echo "- [ ] Define initial actionable tasks"; echo
  echo "## Files"; echo "- $STATUS"; echo "- $NEXT"; echo "- $FOCUS"
} > "$SUMMARY"
echo "✅ Memory refreshed → $SUMMARY"