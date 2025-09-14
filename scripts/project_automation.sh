#!/usr/bin/env bash
set -euo pipefail

# HelmStack Project Automation Script
# Orchestrates common project management workflows

COMMAND="${1:-help}"
WORKSPACE_DIR="${WORKSPACE_DIR:-workspace}"
PLANS_DIR="${PLANS_DIR:-$WORKSPACE_DIR/plans}"
MEMORY_DIR="${MEMORY_DIR:-memory}"

case "$COMMAND" in
    "full-cycle")
        echo "🚀 Running full HelmStack cycle..."

        # 1. Process incoming documents
        echo "📄 Processing documents..."
        make fix

        # 2. Generate work focus
        echo "🎯 Creating focus list..."
        make work

        # 3. Update memory
        echo "🧠 Refreshing memory..."
        make memory >/dev/null

        # 4. Generate analytics if data exists
        echo "📊 Updating analytics..."
        make analytics >/dev/null 2>&1 || echo "   (no analytics data yet)"

        # 5. Show summary
        echo ""
        echo "✅ Full cycle complete!"
        echo ""
        echo "📋 Next steps:"
        head -10 "$PLANS_DIR/FOCUS_LIST.md" 2>/dev/null || echo "   Run 'hs work' to generate focus list"
        echo ""
        echo "💡 Quick commands:"
        echo "   hs status     - Show current status"
        echo "   hs focus      - Show focus list"
        echo "   hs memory     - Show AI memory"
        echo "   hs done       - End of day workflow"
        ;;

    "health-check")
        echo "🏥 HelmStack Health Check"
        echo ""

        # Check directory structure
        echo "📁 Directory Structure:"
        for dir in "$WORKSPACE_DIR/incoming" "$WORKSPACE_DIR/plans" "$WORKSPACE_DIR/research" "$MEMORY_DIR" "snapshots"; do
            if [ -d "$dir" ]; then
                count=$(find "$dir" -name "*.md" 2>/dev/null | wc -l)
                echo "   ✅ $dir ($count files)"
            else
                echo "   ❌ $dir (missing)"
            fi
        done
        echo ""

        # Check key files
        echo "📄 Key Files:"
        key_files=("$PLANS_DIR/STATUS.md" "$PLANS_DIR/NEXT_STEPS.md" "$MEMORY_DIR/MEMORY.md")
        for file in "${key_files[@]}"; do
            if [ -f "$file" ]; then
                size=$(wc -l < "$file")
                echo "   ✅ $(basename "$file") ($size lines)"
            else
                echo "   ⚠️  $(basename "$file") (missing - run 'hs fix')"
            fi
        done
        echo ""

        # Check git status
        echo "📦 Git Status:"
        if [ -d .git ]; then
            uncommitted=$(git status --porcelain | wc -l)
            if [ "$uncommitted" -gt 0 ]; then
                echo "   ⚠️  $uncommitted uncommitted changes"
            else
                echo "   ✅ Working tree clean"
            fi

            if git remote get-url origin >/dev/null 2>&1; then
                echo "   ✅ Remote configured"
            else
                echo "   ⚠️  No remote configured"
            fi
        else
            echo "   ❌ Not a git repository"
        fi
        echo ""

        # Check script permissions
        echo "🔧 Script Health:"
        script_errors=0
        for script in scripts/*.sh scripts/*.py; do
            [ -f "$script" ] || continue
            if [ ! -x "$script" ]; then
                echo "   ⚠️  $(basename "$script") not executable"
                script_errors=$((script_errors + 1))
            fi
        done

        if [ $script_errors -eq 0 ]; then
            echo "   ✅ All scripts executable"
        else
            echo "   💡 Fix with: chmod +x scripts/*.sh scripts/*.py"
        fi
        ;;

    "project-init")
        PROJECT_NAME="${2:-$(basename "$(pwd)")}"
        PROJECT_DESC="${3:-Project initialized with HelmStack automation}"

        echo "🚀 Initializing project: $PROJECT_NAME"

        # Full setup
        make start NAME="$PROJECT_NAME" DESC="$PROJECT_DESC"

        # Initial documentation
        if [ ! -f "$WORKSPACE_DIR/incoming/PROJECT_BRIEF.md" ]; then
            cat > "$WORKSPACE_DIR/incoming/PROJECT_BRIEF.md" << EOF
# $PROJECT_NAME

## Overview
$PROJECT_DESC

## Goals
- [ ] Define project objectives
- [ ] Set up development environment
- [ ] Create initial documentation

## Success Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Timeline
- **Start Date**: $(date +%Y-%m-%d)
- **Target Completion**: TBD

## Resources
- Repository: [Add URL]
- Documentation: [Add links]
- Team: [List team members]
EOF
            echo "📝 Created initial project brief"
        fi

        # Run initial analysis
        make fix
        make work

        echo ""
        echo "✅ Project initialization complete!"
        echo "📂 Next: Add documents to $WORKSPACE_DIR/incoming/ and run 'hs fix'"
        ;;

    "release-prep")
        echo "🚢 Preparing for release..."

        # Ensure clean state
        if [ -d .git ] && [ -n "$(git status --porcelain)" ]; then
            echo "❌ Working tree not clean. Commit changes first."
            exit 1
        fi

        # Run full analysis
        make full-cycle >/dev/null

        # Update documentation
        echo "📚 Updating documentation..."
        make analytics >/dev/null 2>&1 || true

        # Lint and format
        echo "🔧 Running quality checks..."
        make fix-lint >/dev/null 2>&1 || echo "   ⚠️  Linting issues found"
        make fix-format >/dev/null 2>&1 || echo "   ⚠️  Formatting issues found"

        # Version check
        CURRENT_VERSION=$(grep -E "Version-[0-9]" README.md | sed -E 's/.*Version-([0-9.-]+[M0-9]*).*/\1/' || echo "unknown")
        echo "📋 Current version: $CURRENT_VERSION"
        echo ""
        echo "✅ Release preparation complete!"
        echo "💡 Next: Review changes and run version bump"
        echo "   make bump-patch   # for patch release"
        echo "   make bump-minor   # for minor release"
        echo "   make bump-major   # for major release"
        ;;

    "help"|*)
        echo "🤖 HelmStack Project Automation"
        echo ""
        echo "Commands:"
        echo "  full-cycle     - Run complete HelmStack workflow"
        echo "  health-check   - Check project health and structure"
        echo "  project-init   - Initialize new project [NAME] [DESC]"
        echo "  release-prep   - Prepare project for release"
        echo "  help          - Show this help"
        echo ""
        echo "Examples:"
        echo "  $0 full-cycle"
        echo "  $0 health-check"
        echo "  $0 project-init \"MyProject\" \"A great new project\""
        echo "  $0 release-prep"
        ;;
esac
