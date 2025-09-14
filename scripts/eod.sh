#!/usr/bin/env bash
set -e

SNAP_DIR="${1:-snapshots}"
PLANS_DIR="${2:-workspace/plans}"

# Create snapshot directory if needed
mkdir -p "$SNAP_DIR"

# Create snapshot with current state
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
SNAP_FILE="$SNAP_DIR/snap-$TIMESTAMP.txt"

echo "📸 Creating snapshot: $SNAP_FILE"
cat > "$SNAP_FILE" <<EOF
# HelmStack Session Snapshot - $TIMESTAMP

## Modified Files
$(git status --porcelain 2>/dev/null || echo "No git repository")

## Current Plans
$([ -f "$PLANS_DIR/STATUS.md" ] && cat "$PLANS_DIR/STATUS.md" || echo "No STATUS.md found")

## Focus List
$([ -f "$PLANS_DIR/FOCUS_LIST.md" ] && cat "$PLANS_DIR/FOCUS_LIST.md" || echo "No FOCUS_LIST.md found")

## Session Summary
Snapshot created at: $(date)
Working directory: $(pwd)
EOF

# Git operations - safe even if no commits exist
if [ -d .git ]; then
    echo "🔧 Git operations..."

    # Add all changes
    git add .

    # Check if there are changes to commit
    if git diff --cached --quiet; then
        echo "ℹ️ No changes to commit"
    else
        # Commit with session timestamp
        git commit -m "session: End of day snapshot $TIMESTAMP

📊 Session completed with HelmStack
🕐 Timestamp: $(date)
📁 Snapshot: $SNAP_FILE" || echo "⚠️ Commit failed"
    fi

    # Create tag for this session (optional)
    SESSION_TAG="session-$TIMESTAMP"
    git tag -f "$SESSION_TAG" 2>/dev/null || echo "ℹ️ Could not create tag"

    # Push if remote exists (safe if it fails)
    if git remote get-url origin >/dev/null 2>&1; then
        echo "🚀 Pushing to remote..."
        git push origin main --tags 2>/dev/null || echo "⚠️ Push failed (maybe no remote or network issue)"
    else
        echo "ℹ️ No remote configured - skipping push"
    fi

    # If no HEAD exists (fresh repo), create initial commit
    if ! git rev-parse --verify HEAD >/dev/null 2>&1; then
        echo "🆕 Creating initial commit..."
        git add .
        git commit -m "init: HelmStack project initialization

🚀 Project started with HelmStack
📅 Date: $(date)
📝 Initial setup complete" || echo "⚠️ Initial commit failed"
    fi
else
    echo "ℹ️ Not a git repository - skipping git operations"
fi

echo "✅ End of day complete!"
echo "📊 Session summary saved to: $SNAP_FILE"
