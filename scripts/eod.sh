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

    # Check if no HEAD exists (fresh repo) and create initial commit first
    if ! git rev-parse --verify HEAD >/dev/null 2>&1; then
        echo "🆕 Fresh repository detected - creating initial commit..."
        git add .
        if git diff --cached --quiet; then
            echo "ℹ️ No files to commit in fresh repo"
        else
            git commit -m "init: HelmStack project initialization

🚀 Project started with HelmStack
📅 Date: $(date)
📝 Initial setup complete" || echo "⚠️ Initial commit failed"
        fi
    fi

    # Add all changes
    git add .

    # Check if there are changes to commit
    if git diff --cached --quiet; then
        echo "ℹ️ No changes to commit"
        HAS_CHANGES=false
    else
        echo "📝 Changes detected - creating session commit..."
        # Commit with session timestamp
        git commit -m "session: End of day snapshot $TIMESTAMP

📊 Session completed with HelmStack
🕐 Timestamp: $(date)
📁 Snapshot: $SNAP_FILE" || echo "⚠️ Commit failed"
        HAS_CHANGES=true
    fi

    # Create tag for this session (only if we have commits)
    if git rev-parse --verify HEAD >/dev/null 2>&1; then
        SESSION_TAG="session-$TIMESTAMP"
        git tag -f "$SESSION_TAG" 2>/dev/null || echo "ℹ️ Could not create tag"
    fi

    # Push if remote exists (safe if it fails)
    if git remote get-url origin >/dev/null 2>&1; then
        # Try to detect default branch
        DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main")

        echo "🚀 Pushing to remote branch: $DEFAULT_BRANCH..."
        git push origin "$DEFAULT_BRANCH" --tags 2>/dev/null || {
            echo "⚠️ Push to $DEFAULT_BRANCH failed, trying 'main'..."
            git push origin main --tags 2>/dev/null || {
                echo "⚠️ Push to main failed too - maybe no network or auth issue"
            }
        }
    else
        echo "ℹ️ No remote configured - skipping push"
    fi
else
    echo "ℹ️ Not a git repository - initializing git..."
    git init
    echo "✅ Git repository initialized"
fi

echo "✅ End of day complete!"
echo "📊 Session summary saved to: $SNAP_FILE"
