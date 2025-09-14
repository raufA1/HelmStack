#!/usr/bin/env bash
set -euo pipefail
INCOMING_DIR="${1:-workspace/incoming}"
PLANS_DIR="${2:-workspace/plans}"
mkdir -p "$PLANS_DIR"
DOC_SRC=""
if ls "${INCOMING_DIR}"/*.md >/dev/null 2>&1; then
  DOC_SRC=$(ls "${INCOMING_DIR}"/*.md | head -n1)
fi
{
  echo "# STATUS"; echo
  echo "- Updated: $(date '+%Y-%m-%d %H:%M')"
  [ -n "$DOC_SRC" ] && echo "- Source doc: ${DOC_SRC}" || echo "- Source doc: (none)"
  echo "- State: planning"
} > "${PLANS_DIR}/STATUS.md"
{
  echo "# NEXT_STEPS"; echo
  [ -n "$DOC_SRC" ] && grep -E '^[[:space:]]*[-*][[:space:]]+' "$DOC_SRC" \
    | sed 's/^[[:space:]]*[-*][[:space:]]\+/- [ ] /' || true
} > "${PLANS_DIR}/NEXT_STEPS.md"
if ! grep -q "\[ \]" "${PLANS_DIR}/NEXT_STEPS.md"; then
cat >> "${PLANS_DIR}/NEXT_STEPS.md" <<'EOF'
- [ ] Define core data model
- [ ] Implement storage layer
- [ ] Implement CLI commands
- [ ] Write README usage examples
- [ ] Add tests
EOF
fi
echo "✅ Updated: ${PLANS_DIR}/STATUS.md, ${PLANS_DIR}/NEXT_STEPS.md"