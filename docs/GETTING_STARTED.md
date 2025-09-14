# Getting Started with HelmStack

This guide will walk you through setting up HelmStack and using it for your first project.

## Installation

### Method 1: Use as Template (Recommended)

1. **Visit** https://github.com/raufA1/HelmStack
2. **Click** "Use this template" button
3. **Create** your new repository
4. **Clone** your repository:
```bash
git clone git@github.com:yourusername/your-project.git
cd your-project
```

### Method 2: Clone Directly

```bash
git clone git@github.com:raufA1/HelmStack.git my-project
cd my-project
rm -rf .git  # Remove original git history
git init     # Start fresh
```

## First Project Setup

### 1. Initialize Your Project

```bash
make start NAME="MyProject" DESC="Brief project description"
```

This creates the directory structure and initializes the repository.

### 2. Add Your Documents

Put your project documents in `workspace/incoming/`:

```bash
# Example documents
cp project-spec.md workspace/incoming/
cp requirements.docx workspace/incoming/  # Will be extracted
cp wireframes.pdf workspace/incoming/     # Will be extracted
```

### 3. Generate Your Plan

```bash
make fix    # Analyzes documents → creates STATUS.md, NEXT_STEPS.md
make work   # Creates FOCUS_LIST.md from next steps
```

### 4. Review Generated Plans

```bash
make status  # View current status
make next    # View next steps
make focus   # View focus list (top priority items)
```

## Daily Workflow

### Morning Routine

```bash
# Review and update plans
make fix work

# Check productivity from yesterday
make analytics

# Review focus list
make focus
```

### During Work

When you need to research something:

```bash
make ask TOPIC="Should we use React or Vue?"
```

This creates a research thread. Edit the files in `workspace/research/[timestamp]/`:
- `proposal.md` - Your research question and context
- `notes.md` - Research findings and sources
- `decision.md` - Decision status
- `actions.md` - Action items if approved

Review and decide:

```bash
make check  # Review the research
make yes    # Approve (adds actions to NEXT_STEPS)
# or
make no     # Request changes
```

### End of Day

```bash
make done   # Creates snapshot, commits changes, shows analytics
```

## Key Commands to Remember

| Command | Purpose |
|---------|---------|
| `make help` | Show all commands |
| `make fix` | Refresh plan from documents |
| `make work` | Create focus list |
| `make status` | Show current status |
| `make ask TOPIC="..."` | Start research |
| `make done` | End of day routine |
| `make analytics` | Show productivity metrics |

## Understanding the Output

### STATUS.md
Shows current project state, last update time, and source documents.

### NEXT_STEPS.md
All extracted tasks from your documents, organized by priority (‼ urgent, ! high priority).

### FOCUS_LIST.md
Top 5-10 tasks from NEXT_STEPS, organized by priority with section headers.

### Analytics
- **Productivity Score**: 0-10 based on file changes, commits, and work patterns
- **Focus Areas**: Automatically detected from file types and paths
- **Session Duration**: How long you worked
- **Trends**: Compare with previous days

## Advanced Features

### Document Analysis

```bash
make analyze PATH=workspace/incoming              # Run all analyzers
make analyze PATH=spec.md ANALYZER=risk          # Risk analysis only
make analyzers                                   # List available analyzers
```

### Architecture Decisions

```bash
make adr-new TITLE="Database choice"   # Create decision record
make adr-list                          # List all decisions
make adr-accept NUM=001               # Accept a decision
```

### Templates

```bash
make template TYPE=issue FILE=bug-report.md      # GitHub issue template
make template TYPE=epic FILE=user-auth.md        # Epic specification
```

### GitHub Integration

```bash
make setup  # Creates labels, milestones, and issue templates
```

## Next Steps

1. **Customize**: Edit templates in `templates/` directory
2. **Extend**: Create custom analyzers in `scripts/analyzers/`
3. **Integrate**: Set up GitHub repository with `make setup`
4. **Collaborate**: Use research workflow for team decisions
5. **Track**: Monitor productivity with daily analytics

## Troubleshooting

### Common Issues

**"No documents found"**: Make sure documents are in `workspace/incoming/`

**"Pre-commit failed"**: Run with `git commit --no-verify` or fix pre-commit setup

**"Analytics show no data"**: Make sure you've run `make done` to create snapshots

**"GitHub setup fails"**: Install `gh` CLI and run `gh auth login`

### Getting Help

- Check [COMMANDS.md](../COMMANDS.md) for complete command reference
- Review examples in `examples/` directory
- Open issues on GitHub for bugs or questions

## Example Project Structure After Setup

```
my-project/
├─ workspace/
│  ├─ incoming/
│  │  ├─ spec.md                    # Your requirements
│  │  └─ wireframes.pdf            # Design docs
│  └─ plans/
│     ├─ STATUS.md                 # ✅ Generated
│     ├─ NEXT_STEPS.md            # ✅ Generated
│     └─ FOCUS_LIST.md            # ✅ Generated
├─ memory/
│  ├─ SUMMARY.md                   # ✅ Auto-updated
│  └─ DECISIONS.md                # ✅ Decision log
└─ snapshots/                      # ✅ EOD snapshots
```

Ready to start? Run `make start` and begin your systematic project management journey! 🚀