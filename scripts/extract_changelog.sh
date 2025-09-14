#!/usr/bin/env bash
set -euo pipefail

# Extract latest version section from CHANGELOG.md
CHANGELOG_FILE="${1:-CHANGELOG.md}"
VERSION="${2:-}"

if [ ! -f "$CHANGELOG_FILE" ]; then
    echo "Error: CHANGELOG.md not found" >&2
    exit 1
fi

if [ -z "$VERSION" ]; then
    # Extract the first version section (latest)
    awk '
        /^## \[/ {
            if (in_section) exit;
            in_section = 1;
            next;
        }
        in_section && /^## / {
            exit;
        }
        in_section {
            print;
        }
    ' "$CHANGELOG_FILE"
else
    # Extract specific version section
    awk -v version="$VERSION" '
        $0 ~ "^## \\[" version "\\]" {
            in_section = 1;
            next;
        }
        in_section && /^## / {
            exit;
        }
        in_section {
            print;
        }
    ' "$CHANGELOG_FILE"
fi
