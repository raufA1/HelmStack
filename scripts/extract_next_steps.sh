#!/usr/bin/env bash
set -euo pipefail
PLANS_DIR="${1:-workspace/plans}"
NEXT="${PLANS_DIR}/NEXT_STEPS.md"
FOCUS="${PLANS_DIR}/FOCUS_LIST.md"
[ -f "$NEXT" ] || { echo "WARN: $NEXT not found. Run 'make fix' first."; exit 0; }

# Create temporary files for priority sorting
URGENT_TMP="${PLANS_DIR}/_urgent.tmp"
HIGH_TMP="${PLANS_DIR}/_high.tmp"
NORMAL_TMP="${PLANS_DIR}/_normal.tmp"

# Extract tasks by priority
grep "^- \\[ \\]" "$NEXT" | while IFS= read -r line; do
  if [[ "$line" == *"‼"* ]]; then
    echo "$line" >> "$URGENT_TMP"
  elif [[ "$line" == *"!"* ]]; then
    echo "$line" >> "$HIGH_TMP"
  else
    echo "$line" >> "$NORMAL_TMP"
  fi
done

# Build focus list with priorities
{
  echo "# FOCUS_LIST"; echo

  # Add urgent tasks first (‼)
  if [ -f "$URGENT_TMP" ]; then
    echo "## 🚨 Urgent"; echo
    cat "$URGENT_TMP"; echo
  fi

  # Add high priority tasks (!)
  if [ -f "$HIGH_TMP" ]; then
    echo "## ⚡ High Priority"; echo
    cat "$HIGH_TMP"; echo
  fi

  # Add normal tasks (limit to 5-8 total items)
  if [ -f "$NORMAL_TMP" ]; then
    urgent_count=$(wc -l < "$URGENT_TMP" 2>/dev/null || echo 0)
    high_count=$(wc -l < "$HIGH_TMP" 2>/dev/null || echo 0)
    remaining=$((10 - urgent_count - high_count))

    if [ $remaining -gt 0 ]; then
      echo "## 📋 Next Tasks"; echo
      head -n "$remaining" "$NORMAL_TMP" 2>/dev/null || true
    fi
  fi
} > "$FOCUS"

# Clean up temp files
rm -f "$URGENT_TMP" "$HIGH_TMP" "$NORMAL_TMP"

# Add default task if no tasks found
grep -q "^- \\[ \\]" "$FOCUS" || echo "- [ ] Pick one actionable task and start." >> "$FOCUS"

echo "✅ Focus ready: $FOCUS (prioritized by ‼/! markers)"