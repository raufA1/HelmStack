#!/usr/bin/env bash
set -euo pipefail
INCOMING_DIR="${1:-workspace/incoming}"
PLANS_DIR="${2:-workspace/plans}"
mkdir -p "$PLANS_DIR"

# Count all .md files
ALL=$(ls "${INCOMING_DIR}"/*.md 2>/dev/null | wc -l || echo 0)

# Create combined document if any .md files exist
if [ "$ALL" -gt 0 ]; then
  # Combine all .md files
  cat "${INCOMING_DIR}"/*.md > "${PLANS_DIR}/_combined.md"
  DOC_COUNT="$ALL files"

  # Extract tasks from combined document
  grep -E '^[[:space:]]*[-*][[:space:]]+' "${PLANS_DIR}/_combined.md" \
    | sed 's/^[[:space:]]*[-*][[:space:]]\+/- [ ] /' > "${PLANS_DIR}/_tasks.tmp" || true

  # Extract epics (## heading lines) for future use
  grep -E '^##[[:space:]]+' "${PLANS_DIR}/_combined.md" \
    | sed 's/^##[[:space:]]\+/- Epic: /' > "${PLANS_DIR}/_epics.tmp" || true
else
  DOC_COUNT="no docs"
  touch "${PLANS_DIR}/_tasks.tmp"
  touch "${PLANS_DIR}/_epics.tmp"
fi

# Write STATUS.md
{
  echo "# STATUS"; echo
  echo "- Updated: $(date '+%Y-%m-%d %H:%M')"
  echo "- Source docs: ${DOC_COUNT}"
  echo "- State: planning"
} > "${PLANS_DIR}/STATUS.md"

# Write NEXT_STEPS.md with extracted tasks
{
  echo "# NEXT_STEPS"; echo
  if [ -s "${PLANS_DIR}/_tasks.tmp" ]; then
    cat "${PLANS_DIR}/_tasks.tmp"
  fi
} > "${PLANS_DIR}/NEXT_STEPS.md"

# Add default tasks if no tasks were found
if ! grep -q "\[ \]" "${PLANS_DIR}/NEXT_STEPS.md"; then
cat >> "${PLANS_DIR}/NEXT_STEPS.md" <<'EOF'
- [ ] Define core data model
- [ ] Implement storage layer
- [ ] Implement CLI commands
- [ ] Write README usage examples
- [ ] Add tests
EOF
fi

# Clean up temporary files
rm -f "${PLANS_DIR}/_tasks.tmp" "${PLANS_DIR}/_epics.tmp" "${PLANS_DIR}/_combined.md"

echo "✅ Updated: ${PLANS_DIR}/STATUS.md, ${PLANS_DIR}/NEXT_STEPS.md (processed ${DOC_COUNT})"