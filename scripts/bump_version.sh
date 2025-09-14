#!/usr/bin/env bash
set -euo pipefail

# Semantic version bumping script
BUMP_TYPE="${1:-patch}"
DRY_RUN="${2:-false}"

usage() {
    echo "Usage: $0 [major|minor|patch] [dry-run]"
    echo ""
    echo "Examples:"
    echo "  $0 patch        # 1.0.0 → 1.0.1"
    echo "  $0 minor        # 1.0.0 → 1.1.0"
    echo "  $0 major        # 1.0.0 → 2.0.0"
    echo "  $0 patch dry-run  # Show what would change"
    exit 1
}

case "$BUMP_TYPE" in
    major|minor|patch) ;;
    *) usage ;;
esac

# Get current version from Makefile
CURRENT_VERSION=$(grep -E "Version-[0-9]" README.md | sed -E 's/.*Version-([0-9.-]+[M0-9]*).*/\1/' || echo "1.0.0-M5")

echo "Current version: $CURRENT_VERSION"

# Remove milestone suffix for versioning
BASE_VERSION=$(echo "$CURRENT_VERSION" | sed 's/-M[0-9]*$//')

# Parse version components
IFS='.' read -r -a VERSION_PARTS <<< "$BASE_VERSION"
MAJOR=${VERSION_PARTS[0]}
MINOR=${VERSION_PARTS[1]}
PATCH=${VERSION_PARTS[2]}

# Bump version
case "$BUMP_TYPE" in
    major)
        MAJOR=$((MAJOR + 1))
        MINOR=0
        PATCH=0
        ;;
    minor)
        MINOR=$((MINOR + 1))
        PATCH=0
        ;;
    patch)
        PATCH=$((PATCH + 1))
        ;;
esac

NEW_VERSION="$MAJOR.$MINOR.$PATCH"
echo "New version: $NEW_VERSION"

if [ "$DRY_RUN" = "dry-run" ]; then
    echo "DRY RUN - Would update:"
    echo "  - README.md badges"
    echo "  - Makefile version"
    echo "  - CHANGELOG.md unreleased section"
    exit 0
fi

# Update version in files
echo "Updating version in files..."

# Update README.md badge
sed -i "s/Version-[^-]*--M[0-9]*/Version-$NEW_VERSION/g" README.md
sed -i "s/Version-[^-]*-/Version-$NEW_VERSION-/g" README.md

# Update Makefile version command
sed -i "s/HelmStack v[0-9.-]*M[0-9]*/HelmStack v$NEW_VERSION/g" Makefile

# Update CHANGELOG.md unreleased section
if grep -q "## \[Unreleased\]" CHANGELOG.md; then
    # Replace Unreleased with version and date
    TODAY=$(date +%Y-%m-%d)
    sed -i "s/## \[Unreleased\]/## [$NEW_VERSION] - $TODAY/" CHANGELOG.md

    # Add new Unreleased section at the top
    sed -i "/## \[$NEW_VERSION\]/i\\
## [Unreleased]\\
\\
### Added\\
- \\
\\
### Changed\\
- \\
\\
### Fixed\\
- \\
" CHANGELOG.md
fi

echo "✅ Version bumped to $NEW_VERSION"
echo ""
echo "Next steps:"
echo "  1. Review changes: git diff"
echo "  2. Commit: git add . && git commit -m 'chore: bump version to $NEW_VERSION'"
echo "  3. Tag: git tag v$NEW_VERSION"
echo "  4. Push: git push && git push --tags"
