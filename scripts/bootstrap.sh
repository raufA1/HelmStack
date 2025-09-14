#!/usr/bin/env bash
set -euo pipefail

if ! command -v gh >/dev/null 2>&1; then
  echo "❌ gh CLI not found. Install & run: gh auth login"
  echo "   📖 https://cli.github.com/"
  exit 0
fi

echo "🚀 Bootstrapping GitHub repository..."

# Create standard labels
echo "📋 Creating labels..."
gh label create "ready" -c "#2ea44f" -d "Ready to work" 2>/dev/null || true
gh label create "blocked" -c "#d73a4a" -d "Blocked" 2>/dev/null || true
gh label create "epic" -c "#7f00ff" -d "Epic feature" 2>/dev/null || true
gh label create "urgent" -c "#ff0000" -d "Urgent priority" 2>/dev/null || true
gh label create "high-priority" -c "#ff8800" -d "High priority" 2>/dev/null || true
gh label create "research" -c "#0066cc" -d "Research needed" 2>/dev/null || true
gh label create "task" -c "#28a745" -d "Standard task" 2>/dev/null || true
gh label create "bug" -c "#d73a4a" -d "Bug fix" 2>/dev/null || true
gh label create "enhancement" -c "#a2eeef" -d "Enhancement" 2>/dev/null || true
gh label create "documentation" -c "#0075ca" -d "Documentation" 2>/dev/null || true

# Create milestones
echo "🏆 Creating milestones..."
gh api -X POST repos/{owner}/{repo}/milestones -f title="M1: Init" -f description="Initial setup and core features" -f due_on="$(date -d '+2 weeks' --iso-8601)" 2>/dev/null || true
gh api -X POST repos/{owner}/{repo}/milestones -f title="M2: MVP" -f description="Minimum Viable Product" -f due_on="$(date -d '+4 weeks' --iso-8601)" 2>/dev/null || true
gh api -X POST repos/{owner}/{repo}/milestones -f title="M3: Pilot" -f description="Pilot release" -f due_on="$(date -d '+6 weeks' --iso-8601)" 2>/dev/null || true
gh api -X POST repos/{owner}/{repo}/milestones -f title="M4: GA" -f description="General Availability" -f due_on="$(date -d '+8 weeks' --iso-8601)" 2>/dev/null || true

# Create issue templates directory
echo "📝 Setting up issue templates..."
mkdir -p .github/ISSUE_TEMPLATE

# Create bug report template
cat > .github/ISSUE_TEMPLATE/bug_report.md << 'EOF'
---
name: Bug Report
about: Create a report to help us improve
title: '[BUG] '
labels: bug
assignees: ''
---

**Describe the bug**
A clear and concise description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

**Expected behavior**
A clear and concise description of what you expected to happen.

**Environment:**
- OS: [e.g. Ubuntu 22.04]
- Version: [e.g. v1.0.0]

**Additional context**
Add any other context about the problem here.
EOF

# Create feature request template
cat > .github/ISSUE_TEMPLATE/feature_request.md << 'EOF'
---
name: Feature Request
about: Suggest an idea for this project
title: '[FEATURE] '
labels: enhancement
assignees: ''
---

**Is your feature request related to a problem?**
A clear and concise description of what the problem is.

**Describe the solution you'd like**
A clear and concise description of what you want to happen.

**Describe alternatives you've considered**
A clear and concise description of any alternative solutions.

**Epic**
Which epic does this feature belong to?

**Additional context**
Add any other context or screenshots about the feature request here.
EOF

# Create task template
cat > .github/ISSUE_TEMPLATE/task.md << 'EOF'
---
name: Task
about: Standard development task
title: '[TASK] '
labels: task
assignees: ''
---

**Description**
Clear description of the task.

**Acceptance Criteria**
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

**Epic**
Which epic does this task belong to?

**Priority**
- [ ] Urgent
- [ ] High
- [ ] Medium
- [ ] Low

**Estimate**
How much effort is expected?

**Notes**
Any additional notes or context.
EOF

# Create research template
cat > .github/ISSUE_TEMPLATE/research.md << 'EOF'
---
name: Research
about: Research or investigation task
title: '[RESEARCH] '
labels: research
assignees: ''
---

**Research Question**
What question needs to be answered?

**Background**
Why is this research needed?

**Scope**
What areas should be investigated?

**Success Criteria**
- [ ] Question answered
- [ ] Recommendation provided
- [ ] Next steps identified

**Timeline**
When is this needed by?

**Resources**
Any specific resources or constraints?
EOF

echo "✅ GitHub bootstrap complete!"
echo ""
echo "📋 Created labels: ready, blocked, epic, urgent, high-priority, research, task, bug, enhancement, documentation"
echo "🏆 Created milestones: M1-M4 with due dates"
echo "📝 Created issue templates: bug_report, feature_request, task, research"
echo ""
echo "🔗 Next steps:"
echo "   • Set up branch protection rules in Settings → Branches"
echo "   • Configure project board if needed"
echo "   • Add GH_TOKEN_PROJECT secret for auto-project-add workflow"