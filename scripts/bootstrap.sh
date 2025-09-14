#!/usr/bin/env bash
set -euo pipefail
if ! command -v gh >/dev/null 2>&1; then
  echo "gh CLI not found. Install & run: gh auth login"; exit 0; fi
echo "Bootstrapping GitHub..."
gh label create "ready" -c "#2ea44f" -d "Ready to work" 2>/dev/null || true
gh label create "blocked" -c "#d73a4a" -d "Blocked" 2>/dev/null || true
gh api -X POST repos/{owner}/{repo}/milestones -f title="M1: Init" 2>/dev/null || true
gh api -X POST repos/{owner}/{repo}/milestones -f title="M2: MVP" 2>/dev/null || true
echo "✅ Done."