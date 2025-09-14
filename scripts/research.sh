#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-}"; DIR="${2:-workspace/research}"; PLANS_DIR="${3:-workspace/plans}"; MEM_DIR="${4:-memory}"
mkdir -p "$DIR"
case "$CMD" in
  ask)  TOPIC="${3:-${TOPIC:-}}"; [ -n "$TOPIC" ] || { echo "TOPIC required"; exit 1; }
        TS="$(date '+%Y%m%d-%H%M%S')"; THREAD="$DIR/$TS"; mkdir -p "$THREAD"

        # Create structured research files
        printf "# Proposal: %s\n\n## Background\n- \n\n## Problem Statement\n- \n\n## Proposed Solution\n- \n\n## Next Steps\n- \n" "$TOPIC" > "$THREAD/proposal.md"

        printf "# Research Notes: %s\n\n## Sources\n- \n\n## Key Findings\n- \n\n## Questions\n- \n" "$TOPIC" > "$THREAD/notes.md"

        printf "# Decision: %s\n\n## Status\n- [ ] Under review\n\n## Reasoning\n- \n\n## Impact\n- \n" "$TOPIC" > "$THREAD/decision.md"

        printf "# Action Items: %s\n\n## Implementation Tasks\n- [ ] \n\n## Dependencies\n- \n\n## Timeline\n- \n" "$TOPIC" > "$THREAD/actions.md"

        echo "✅ Created research thread: $THREAD"
        echo "📝 Files: proposal.md, notes.md, decision.md, actions.md";;

  check)LAST="$(ls -dt "$DIR"/* 2>/dev/null | head -n1 || true)"; [ -n "$LAST" ] || { echo "No research threads"; exit 0; }
        echo "📋 Latest research thread: $(basename "$LAST")"
        echo; echo "=== PROPOSAL ==="
        sed -n '1,40p' "$LAST/proposal.md" 2>/dev/null || echo "(no proposal.md)"
        echo; echo "=== NOTES ==="
        sed -n '1,20p' "$LAST/notes.md" 2>/dev/null || echo "(no notes.md)"
        echo; echo "=== DECISION ==="
        sed -n '1,20p' "$LAST/decision.md" 2>/dev/null || echo "(no decision.md)";;

  yes)  LAST="$(ls -dt "$DIR"/* 2>/dev/null | head -n1 || true)"; [ -n "$LAST" ] || { echo "No research threads"; exit 0; }
        TOPIC_NAME=$(basename "$LAST")

        # Update decision.md
        sed -i 's/- \[ \] Under review/- [x] ✅ APPROVED/g' "$LAST/decision.md"
        echo "- Approved on: $(date '+%Y-%m-%d %H:%M')" >> "$LAST/decision.md"

        # Log to memory
        echo "- $(date '+%Y-%m-%d %H:%M') ✅ APPROVED: $TOPIC_NAME" >> "$MEM_DIR/DECISIONS.md"

        # Copy action items to NEXT_STEPS (prepend)
        if [ -f "$LAST/actions.md" ]; then
          TEMP_NEXT="/tmp/next_steps_temp.md"
          echo "# NEXT_STEPS" > "$TEMP_NEXT"
          echo "" >> "$TEMP_NEXT"
          echo "## From Research: $TOPIC_NAME" >> "$TEMP_NEXT"
          grep "^- \[ \]" "$LAST/actions.md" >> "$TEMP_NEXT" || true
          echo "" >> "$TEMP_NEXT"
          tail -n +3 "$PLANS_DIR/NEXT_STEPS.md" >> "$TEMP_NEXT" 2>/dev/null || true
          mv "$TEMP_NEXT" "$PLANS_DIR/NEXT_STEPS.md"
        fi

        echo "✅ Approved research: $TOPIC_NAME"
        echo "📋 Action items added to NEXT_STEPS.md";;

  no)   LAST="$(ls -dt "$DIR"/* 2>/dev/null | head -n1 || true)"; [ -n "$LAST" ] || { echo "No research threads"; exit 0; }
        TOPIC_NAME=$(basename "$LAST")

        # Update decision.md
        sed -i 's/- \[ \] Under review/- [x] ❌ CHANGES REQUESTED/g' "$LAST/decision.md"
        echo "- Changes requested on: $(date '+%Y-%m-%d %H:%M')" >> "$LAST/decision.md"

        # Log to memory
        echo "- $(date '+%Y-%m-%d %H:%M') ❌ CHANGES REQUESTED: $TOPIC_NAME" >> "$MEM_DIR/DECISIONS.md"
        echo "⏳ Changes requested for: $TOPIC_NAME";;

  end)  LAST="$(ls -dt "$DIR"/* 2>/dev/null | head -n1 || true)"; [ -n "$LAST" ] || { echo "No research threads"; exit 0; }
        TOPIC_NAME=$(basename "$LAST")
        ARCHIVE_NAME="archive_$(date '+%Y%m%d-%H%M')_$TOPIC_NAME"
        mv "$LAST" "$DIR/$ARCHIVE_NAME"
        echo "📁 Archived research thread: $ARCHIVE_NAME";;

  *)    echo "Usage: research.sh [ask|check|yes|no|end]"
        echo ""
        echo "Commands:"
        echo "  ask TOPIC   - Start new research thread"
        echo "  check       - Review latest thread"
        echo "  yes         - Approve and move to NEXT_STEPS"
        echo "  no          - Request changes"
        echo "  end         - Archive thread";;
esac