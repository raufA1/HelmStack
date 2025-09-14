#!/usr/bin/env bash
set -euo pipefail
PLANS_DIR="${1:-workspace/plans}"
NEXT="${PLANS_DIR}/NEXT_STEPS.md"
FOCUS="${PLANS_DIR}/FOCUS_LIST.md"
[ -f "$NEXT" ] || { echo "WARN: $NEXT not found. Run 'make fix' first."; exit 0; }
{
  echo "# FOCUS_LIST"; echo
  grep "^- \\[ \\]" "$NEXT" | head -n 10 || true
} > "$FOCUS"
grep -q "^- \\[ \\]" "$FOCUS" || echo "- [ ] Pick one actionable task and start." >> "$FOCUS"
echo "✅ Focus ready: $FOCUS"