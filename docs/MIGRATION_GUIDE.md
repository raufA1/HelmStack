# HelmStack Migration Guide

This guide helps you migrate existing projects to HelmStack or upgrade between HelmStack versions.

## Table of Contents

1. [Migrating Existing Projects](#migrating-existing-projects)
2. [Version Upgrades](#version-upgrades)
3. [Tool-Specific Migrations](#tool-specific-migrations)
4. [Data Preservation](#data-preservation)
5. [Troubleshooting](#troubleshooting)

## Migrating Existing Projects

### From Traditional Project Management

If you're coming from tools like Jira, Trello, or Asana:

#### Step 1: Export Your Data
```bash
# Create HelmStack structure
make start NAME="MigratedProject" DESC="Migrated from [tool name]"
```

#### Step 2: Convert Your Documents
```bash
# Put your exported documents in incoming/
cp exported-requirements.pdf workspace/incoming/
cp project-notes.docx workspace/incoming/
cp task-list.csv workspace/incoming/  # Convert to markdown first

# Extract text from binary formats
make extract FILE=workspace/incoming/requirements.pdf OUTPUT=workspace/incoming/requirements.md
make extract FILE=workspace/incoming/notes.docx OUTPUT=workspace/incoming/notes.md
```

#### Step 3: Structure Your Tasks
Convert your existing tasks to markdown format:

```markdown
# Project Requirements

## Epic: User Management
- User registration and login !
- Password reset functionality
- User profile management ‼
- Admin user management

## Epic: Core Features
- Feature A implementation
- Feature B development !
- Integration testing
- Documentation updates
```

#### Step 4: Generate Your Plan
```bash
make fix    # Generate STATUS.md, NEXT_STEPS.md
make work   # Create FOCUS_LIST.md
```

### From Git-Based Projects

If you have an existing Git project:

#### Step 1: Add HelmStack to Existing Repository
```bash
cd your-existing-project

# Download HelmStack files
curl -L https://github.com/raufA1/HelmStack/archive/main.tar.gz | tar xz --strip=1

# Initialize HelmStack structure
make start NAME="ExistingProject" DESC="Adding HelmStack to existing project"
```

#### Step 2: Migrate Existing Documentation
```bash
# Move existing docs to incoming/
mv README.md workspace/incoming/project-readme.md
mv docs/*.md workspace/incoming/
mv CONTRIBUTING.md workspace/incoming/contributing.md

# Generate plan from existing docs
make fix work
```

#### Step 3: Preserve Git History
```bash
# HelmStack works with existing git history
git add .
git commit -m "feat: add HelmStack project management system"
```

### From Documentation-Heavy Projects

If you have lots of existing documentation:

#### Step 1: Organize Documents
```bash
# Create incoming structure
mkdir -p workspace/incoming/{requirements,design,planning,technical}

# Organize by type
mv *requirements*.md workspace/incoming/requirements/
mv *design*.md workspace/incoming/design/
mv *architecture*.md workspace/incoming/technical/
```

#### Step 2: Batch Analysis
```bash
# Analyze all documents
make analyze PATH=workspace/incoming

# Extract structured data
make epics
make milestones
make ideas
```

## Version Upgrades

### Upgrading to Latest Version

#### Method 1: Git Pull (if using HelmStack as template)
```bash
# Add upstream remote (one time setup)
git remote add upstream git@github.com:raufA1/HelmStack.git

# Update to latest
git fetch upstream
git merge upstream/main

# Resolve any conflicts in your project-specific files
```

#### Method 2: Manual Update
```bash
# Backup your project data
cp -r workspace/ workspace-backup/
cp -r memory/ memory-backup/
cp -r snapshots/ snapshots-backup/

# Download latest HelmStack
curl -L https://github.com/raufA1/HelmStack/archive/main.tar.gz | tar xz --strip=1 --exclude="workspace" --exclude="memory" --exclude="snapshots"

# Test new version
make help
make fix work
```

### Breaking Changes by Version

#### v1.0.0 to v1.1.0 (Hypothetical)
- **New**: Enhanced analyzer system
- **Changed**: ADR template format
- **Migration**: Run `make adr-migrate` (if implemented)

#### v0.9.x to v1.0.0
- **New**: Session analytics
- **Changed**: Makefile command structure
- **Migration**: Update any custom scripts using old command names

## Tool-Specific Migrations

### From Notion

#### Export Process
1. Export Notion pages as Markdown
2. Organize exported files by project area
3. Clean up Notion-specific formatting

```bash
# After exporting from Notion
find notion-export/ -name "*.md" -exec cp {} workspace/incoming/ \;

# Clean up Notion formatting
sed -i 's/\[\[/[/g' workspace/incoming/*.md  # Fix link format
sed -i 's/\]\]/]/g' workspace/incoming/*.md

# Generate HelmStack structure
make fix work
```

### From Linear/GitHub Issues

#### Using GitHub CLI
```bash
# Export issues to markdown
gh issue list --state all --limit 1000 --json title,body,labels > issues.json

# Convert to HelmStack format (custom script needed)
python3 scripts/convert_issues.py issues.json > workspace/incoming/issues.md

make fix work
```

### From Obsidian

#### Direct Migration
```bash
# Obsidian uses markdown - direct copy works
cp -r obsidian-vault/project-notes/*.md workspace/incoming/

# Convert Obsidian links to standard markdown
sed -i 's/\[\[([^]]*)\]\]/[\1](\1.md)/g' workspace/incoming/*.md

make fix work
```

## Data Preservation

### Backup Strategy

#### Before Migration
```bash
# Create timestamped backup
DATE=$(date +%Y%m%d-%H%M%S)
mkdir -p backups/$DATE

# Backup critical data
cp -r workspace/ backups/$DATE/
cp -r memory/ backups/$DATE/
cp -r snapshots/ backups/$DATE/
cp Makefile backups/$DATE/
cp -r scripts/ backups/$DATE/
```

#### After Migration
```bash
# Verify data integrity
make analyze PATH=workspace/incoming
make status
make next
make focus

# Test core workflows
make ask TOPIC="Migration test"
make check
make end
```

### Data Recovery

#### If Migration Goes Wrong
```bash
# Restore from backup
DATE="20240101-120000"  # Your backup timestamp
rm -rf workspace/ memory/ snapshots/
cp -r backups/$DATE/* ./

# Verify restoration
make status
```

### Gradual Migration

#### Parallel Running
Run both old and new systems temporarily:

```bash
# Keep old system in separate directory
mkdir -p old-system/
mv existing-project-files old-system/

# Set up HelmStack
make start NAME="MigrationTest" DESC="Testing HelmStack"

# Gradually move documents
cp old-system/important-doc.md workspace/incoming/
make fix work

# Compare workflows for a few days before fully switching
```

## Troubleshooting

### Common Migration Issues

#### Problem: Pre-commit Hooks Fail
```bash
# Solution: Update pre-commit config
pre-commit clean
pre-commit install
pre-commit run --all-files
```

#### Problem: Analytics Show No Data
```bash
# Solution: Create initial snapshot
make snapshot
make done  # This creates proper snapshots for analytics
```

#### Problem: Analyzers Can't Process Documents
```bash
# Solution: Check document format
make analyzers  # List available analyzers
make analyze PATH=problematic-doc.md  # Test specific file

# Convert problematic formats
make extract FILE=document.pdf OUTPUT=document.md
```

#### Problem: Commands Don't Work
```bash
# Solution: Check script permissions
chmod +x scripts/*.sh scripts/*.py

# Verify dependencies
python3 --version
make help
```

### Performance Issues After Migration

#### Large Document Sets
```bash
# Break down large documents
split -l 100 large-document.md workspace/incoming/part-

# Or analyze in smaller batches
make analyze PATH=workspace/incoming/part-01.md
make analyze PATH=workspace/incoming/part-02.md
```

#### Many Historical Snapshots
```bash
# Clean old snapshots if needed
find snapshots/ -name "*.txt" -mtime +30 -delete

# Or archive them
mkdir -p archived-snapshots/
mv snapshots/snap-2023*.txt archived-snapshots/
```

### Migration Validation Checklist

- [ ] All important documents moved to `workspace/incoming/`
- [ ] `make fix` generates proper STATUS.md and NEXT_STEPS.md
- [ ] `make work` creates meaningful FOCUS_LIST.md
- [ ] `make analytics` shows session data (after running `make done`)
- [ ] Core workflow (`fix` → `work` → `done`) functions properly
- [ ] Custom analyzers work if you created any
- [ ] ADR system functions for decision tracking
- [ ] Research workflow (`ask` → `check` → `yes`/`no` → `end`) works
- [ ] Templates generate properly
- [ ] GitHub integration works (if using)

### Getting Help

If you encounter issues during migration:

1. **Check Documentation**: Review [Getting Started](GETTING_STARTED.md) and [Commands](../COMMANDS.md)
2. **Create Issue**: Open an issue on GitHub with:
   - Migration source (Notion, Jira, etc.)
   - Error messages
   - Steps to reproduce
3. **Community Support**: Join discussions for migration tips

## Post-Migration Best Practices

### Gradual Adoption
1. **Week 1**: Use basic workflow (`fix`, `work`, `done`)
2. **Week 2**: Add research workflow for decisions
3. **Week 3**: Use ADR system for architecture decisions
4. **Week 4**: Explore analytics and advanced features

### Team Onboarding
```bash
# Create team onboarding document
make template TYPE=todo FILE=team-onboarding.md

# Add to workspace/incoming/ and generate plan
make fix work
```

### Continuous Improvement
```bash
# Regular analytics review
make trends DAYS=30  # Monthly review
make analytics       # Daily insights

# Evolve your documentation structure based on what works
```

Ready to migrate? Start with a small test project to familiarize yourself with the workflow! 🚀