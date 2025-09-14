#!/usr/bin/env bash
set -euo pipefail

# HelmStack Community Edition - Basic End of Day
# Simple session completion without advanced features

SNAP_DIR="$1"
PLANS_DIR="$2"

# Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}🌅 HelmStack Community - End of Day${NC}"

# Create snapshots directory
mkdir -p "$SNAP_DIR"

# Generate basic snapshot
SNAPSHOT_FILE="$SNAP_DIR/snap-$(date +%Y-%m-%d-%H-%M).txt"

cat > "$SNAPSHOT_FILE" << EOF
# HelmStack Community Session Snapshot
Generated: $(date)

## Session Summary

**Duration:** $(date +%H:%M) session
**Project:** $(basename "$(pwd)")

## Current Status

EOF

# Include basic status if available
if [ -f "$PLANS_DIR/STATUS.md" ]; then
    echo "### Project Status" >> "$SNAPSHOT_FILE"
    echo "" >> "$SNAPSHOT_FILE"
    head -20 "$PLANS_DIR/STATUS.md" >> "$SNAPSHOT_FILE" 2>/dev/null || true
    echo "" >> "$SNAPSHOT_FILE"
fi

# Include focus list if available
if [ -f "$PLANS_DIR/FOCUS_LIST.md" ]; then
    echo "### Focus List" >> "$SNAPSHOT_FILE"
    echo "" >> "$SNAPSHOT_FILE"
    cat "$PLANS_DIR/FOCUS_LIST.md" >> "$SNAPSHOT_FILE" 2>/dev/null || true
    echo "" >> "$SNAPSHOT_FILE"
fi

# Basic git status if in git repo
if [ -d ".git" ]; then
    echo "### Git Status" >> "$SNAPSHOT_FILE"
    echo "" >> "$SNAPSHOT_FILE"
    echo "\`\`\`" >> "$SNAPSHOT_FILE"
    git status --short >> "$SNAPSHOT_FILE" 2>/dev/null || echo "No git changes" >> "$SNAPSHOT_FILE"
    echo "\`\`\`" >> "$SNAPSHOT_FILE"
    echo "" >> "$SNAPSHOT_FILE"
fi

# Session completion note
cat >> "$SNAPSHOT_FILE" << 'EOF'

## Session Complete

- ✅ Basic snapshot created
- 📁 Files organized in workspace
- 🎯 Ready for next session

## Next Session

1. Run `hs fix` to refresh plans
2. Review focus list with `hs focus`
3. Continue with planned activities

---

*💡 Want advanced session analytics? Upgrade to HelmStack Pro for:*
- *Detailed productivity metrics*
- *Session-to-session comparisons*
- *AI-powered insights*
- *Advanced automation*

*Learn more: https://helmstack.dev/pro*

*HelmStack Community Edition v2.1.0*
EOF

echo -e "${GREEN}✅${NC} Session snapshot saved: $(basename "$SNAPSHOT_FILE")"

# Optional git commit if there are changes
if [ -d ".git" ] && ! git diff --quiet HEAD 2>/dev/null; then
    echo -e "${YELLOW}💭${NC} Git changes detected - consider committing:"
    echo "   hs commit MSG='End of day - $(date +%Y-%m-%d)'"
fi

echo -e "${CYAN}🎯${NC} Session completed successfully!"
echo -e "${YELLOW}💡${NC} Next: Review snapshot in $SNAP_DIR/"