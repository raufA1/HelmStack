#!/usr/bin/env bash
set -euo pipefail

PLANS_DIR="${1:-workspace/plans}"
MEM_DIR="${2:-memory}"

# Ensure directories exist
mkdir -p "$MEM_DIR"

# Define file paths
STATUS="$PLANS_DIR/STATUS.md"
NEXT="$PLANS_DIR/NEXT_STEPS.md"
FOCUS="$PLANS_DIR/FOCUS_LIST.md"
SUMMARY="$MEM_DIR/SUMMARY.md"
DECISIONS="$MEM_DIR/DECISIONS.md"
OPEN_Q="$MEM_DIR/OPEN_QUESTIONS.md"
GLOSSARY="$MEM_DIR/GLOSSARY.md"

# Ensure memory files exist
touch "$DECISIONS" "$OPEN_Q" "$GLOSSARY"

# Get top tasks
TOP=""
if [ -f "$NEXT" ]; then
    TOP=$(grep '^- \[ \]' "$NEXT" | head -n5 || echo "")
fi

# Generate summary
PROJECT_NAME=$(basename "$(pwd)")
TIMESTAMP=$(date '+%Y-%m-%d %H:%M')

cat > "$SUMMARY" << EOF
# Project Summary (Auto-refreshed)

## Name
$PROJECT_NAME

## Current Status (last update: $TIMESTAMP)
- Milestone: M1 (init)
- Focus: (see FOCUS_LIST)

## Decisions
$(if [ -s "$DECISIONS" ]; then sed -n '2,11p' "$DECISIONS" 2>/dev/null || echo "(no decisions yet)"; else echo "(no decisions yet)"; fi)

## Next Steps (top 5)
$(if [ -n "$TOP" ]; then echo "$TOP"; else echo "- [ ] Define initial actionable tasks"; fi)

## Files
- $STATUS
- $NEXT
- $FOCUS
EOF

echo "✅ Memory refreshed → $SUMMARY"