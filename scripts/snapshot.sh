#!/usr/bin/env bash
set -euo pipefail
SNAP_DIR="${1:-snapshots}"
mkdir -p "$SNAP_DIR"
OUT="${SNAP_DIR}/snap-$(date '+%Y%m%d-%H%M%S').txt"
{
  echo "=== SNAPSHOT @ $(date '+%F %T') ==="; echo
  echo "## git status"; git status -sb || true; echo
  echo "## last commits"
  if git rev-parse --verify HEAD >/dev/null 2>&1; then git --no-pager log --oneline -n 10 || true
  else echo "(no commits yet)"; fi
  echo; echo "## diff"
  if git rev-parse --verify HEAD >/dev/null 2>&1; then git --no-pager diff || true
  else echo "(no diff; repo has no commits yet)"; fi
} > "$OUT"
echo "✅ Snapshot: $OUT"