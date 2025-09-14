# 📋 HelmStack Commands Reference

Complete reference for all HelmStack commands, organized by function.

## 🚀 Core Workflow

### `make start`
**Initialize new project with complete workspace structure**
```bash
make start NAME="ProjectName" DESC="Project description"
```
- Creates all necessary directories (`workspace/`, `memory/`, `snapshots/`)
- Sets up git repository if needed
- Installs pre-commit hooks
- Generates initial project document

### `make fix`
**Refresh project plan from documents**
```bash
make fix
```
- Analyzes all documents in `workspace/incoming/`
- Generates `STATUS.md` and `NEXT_STEPS.md`
- Refreshes AI memory system
- **Alias:** `make plan`

### `make work`
**Generate focus list from next steps**
```bash
make work
```
- Extracts top priorities from `NEXT_STEPS.md`
- Creates `FOCUS_LIST.md` for daily work
- Updates memory with current focus

### `make done`
**Complete session with snapshot and git operations**
```bash
make done
```
- Creates timestamped snapshot
- Commits all changes
- Creates session tag
- Pushes to remote (if configured)
- Handles repos with no HEAD safely

## 📄 Document Analysis

### `make analyze`
**Analyze documents with pluggable analyzers**
```bash
make analyze PATH=workspace/incoming
make analyze PATH=specific-file.md
```
- Uses all available analyzers
- Extracts tasks, epics, risks, metrics
- Supports markdown, PDF, DOCX formats

### `make epics`
**Extract project epics from documents**
```bash
make epics
```
- Identifies major project themes
- Groups related tasks
- Generates `EPICS.md`

### `make milestones`
**Extract project milestones**
```bash
make milestones
```
- Identifies key project checkpoints
- Creates timeline structure

### `make ideas`
**Extract ideas and suggestions**
```bash
make ideas
```
- Captures innovative thoughts
- Identifies improvement opportunities

### `make risks`
**Analyze risks and blockers**
```bash
make risks
```
- Identifies potential problems
- Assesses severity levels
- Generates risk mitigation suggestions

### `make blockers`
**Show current blockers**
```bash
make blockers
```
- Lists immediate obstacles
- Shows blocker severity
- Creates `BLOCKERS.md`

## 🧠 AI Memory System

### `make memory`
**Show comprehensive AI memory summary**
```bash
make memory
```
- Displays complete project state
- Includes all workspace analysis
- Shows recent decisions and progress

### `make context`
**Show quick context for current session**
```bash
make context
```
- Provides immediate next steps
- Shows key file locations
- Optimized for quick reference

### `make refresh`
**Manually refresh AI memory**
```bash
make refresh
```
- Updates memory from all workspace files
- Rebuilds comprehensive summary
- **Alias:** Called automatically by other commands

## 🔍 Research Workflow (HITL)

### `make ask`
**Start research thread**
```bash
make ask TOPIC="Research question"
```
- Initiates human-in-the-loop research
- Creates research workspace
- Documents research question

### `make check`
**Review research findings**
```bash
make check
```
- Summarizes research results
- Presents findings for approval
- Prepares decision point

### `make yes`
**Approve research proposal**
```bash
make yes
```
- Accepts research findings
- Integrates into project plans
- Updates next steps

### `make no`
**Request research changes**
```bash
make no
```
- Rejects current findings
- Requests additional research
- Maintains research thread

### `make end`
**Complete research thread**
```bash
make end
```
- Closes research session
- Archives findings
- Updates project memory

## 📊 Analytics & Metrics

### `make analytics`
**Session productivity analytics**
```bash
make analytics
```
- Shows current session metrics
- Analyzes file changes
- Calculates productivity scores

### `make trends`
**Productivity trends over time**
```bash
make trends DAYS=7
make trends DAYS=30
```
- Shows productivity patterns
- Identifies work cycles
- Default: 7 days

### `make productivity`
**Real productivity metrics**
```bash
make productivity
```
- Git commit analysis
- TODO completion rates
- Session efficiency metrics

### `make timeline`
**Project timeline**
```bash
make timeline
```
- Git commit history
- Visual project evolution
- Key milestone markers

### `make snapshot`
**Create session snapshot**
```bash
make snapshot
```
- Captures current state
- Documents session progress
- Creates timestamped record

## 🏗️ Architecture Decisions (ADR)

### `make adr-new`
**Create new Architecture Decision Record**
```bash
make adr-new TITLE="Decision title"
```
- Creates numbered ADR file
- Uses standard ADR template
- Tracks decision context

### `make adr-list`
**List all ADRs**
```bash
make adr-list
```
- Shows all decisions
- Displays status (Proposed/Accepted/Rejected)
- Ordered by creation date

### `make adr-accept`
**Accept ADR**
```bash
make adr-accept ID=001
```
- Marks ADR as accepted
- Updates decision status
- Integrates into project plans

### `make adr-reject`
**Reject ADR**
```bash
make adr-reject ID=001
```
- Marks ADR as rejected
- Documents rejection reasons
- Maintains decision history

## 📝 Templates & Tools

### `make template`
**Generate templates**
```bash
make template TYPE=todo FILE=tasks.md
make template TYPE=spec FILE=requirements.md
make template TYPE=adr FILE=decision.md
```
- Creates structured templates
- Supports multiple template types
- Customizable content

### `make templates`
**List available templates**
```bash
make templates
```
- Shows all template types
- Displays usage examples

### `make extract`
**Extract text from binary documents**
```bash
make extract FILE=document.pdf OUTPUT=document.md
make extract FILE=document.docx OUTPUT=document.md
```
- Converts PDF/DOCX to markdown
- Preserves document structure
- Enables document analysis

## 🔧 Status & Management

### `make status`
**Show current project status**
```bash
make status
```
- Displays `STATUS.md` content
- Shows project health
- Key metrics overview

### `make next`
**Show next steps**
```bash
make next
```
- Displays `NEXT_STEPS.md`
- Priority-ordered tasks
- Action items list

### `make focus`
**Show current focus list**
```bash
make focus
```
- Displays `FOCUS_LIST.md`
- Today's priorities
- Actionable items only

### `make clean`
**Clean generated files**
```bash
make clean
```
- Removes temporary snapshots
- Cleans focus lists
- Preserves source documents

### `make log`
**Show session log**
```bash
make log
```
- Recent session activity
- Change history
- Activity timeline

## 🔗 Git & GitHub Integration

### `make commit`
**Commit with message**
```bash
make commit MSG="Commit message"
```
- Commits all changes
- Requires commit message
- Adds all modified files

### `make push`
**Push to remote**
```bash
make push
```
- Pushes commits and tags
- Safe operation (continues on failure)

### `make gh-create`
**Create GitHub repository**
```bash
make gh-create NAME="repo-name" DESC="Description" PRIVATE=true
```
- Creates GitHub repository
- Adds SSH remote
- Configures for push

### `make gh-push`
**Initial push to GitHub**
```bash
make gh-push
```
- First push to GitHub
- Sets up tracking branch

### `make pr`
**Create Pull Request**
```bash
make pr TITLE="PR Title" BODY="PR Description"
```
- Creates GitHub Pull Request
- Uses GitHub CLI

### `make setup`
**Bootstrap GitHub integration**
```bash
make setup
```
- Complete GitHub setup
- Repository creation
- Initial configuration

## 🛠️ Development & Quality

### `make fix-lint`
**Fix linting issues**
```bash
make fix-lint
```
- Runs ruff with auto-fix
- Resolves code quality issues
- Python script linting

### `make fix-format`
**Fix code formatting**
```bash
make fix-format
```
- Runs black formatter
- Standardizes code style

### `make fix-yaml`
**Fix YAML formatting**
```bash
make fix-yaml
```
- Validates YAML files
- Checks workflow syntax

## 🔍 Advanced Analysis

### `make analyzers`
**List available analyzers**
```bash
make analyzers
```
- Shows pluggable analyzers
- Analyzer capabilities
- Usage information

### `make dependencies`
**Dependency analysis**
```bash
make dependencies
```
- Identifies project dependencies
- Creates dependency map
- Shows relationships

## 📖 Help & Information

### `make help`
**Show colorful help**
```bash
make help
```
- Complete command reference
- Color-coded by category
- Usage examples

### `make version`
**Show HelmStack version**
```bash
make version
```
- Current version information
- Repository link
- System details

---

## Command Categories Summary

| Category | Commands | Purpose |
|----------|----------|---------|
| **Core Workflow** | `start`, `fix`, `work`, `done` | Main project workflow |
| **Document Analysis** | `analyze`, `epics`, `risks`, `ideas` | Document processing |
| **Memory System** | `memory`, `context`, `refresh` | AI memory management |
| **Research (HITL)** | `ask`, `check`, `yes`, `no`, `end` | Human-in-the-loop research |
| **Analytics** | `analytics`, `trends`, `productivity` | Project metrics |
| **ADR System** | `adr-new`, `adr-list`, `adr-accept` | Decision tracking |
| **Templates** | `template`, `templates`, `extract` | Document generation |
| **Status** | `status`, `next`, `focus`, `clean` | Project status |
| **Git/GitHub** | `commit`, `push`, `gh-create`, `pr` | Version control |
| **Quality** | `fix-lint`, `fix-format`, `fix-yaml` | Code quality |
| **Advanced** | `analyzers`, `dependencies`, `timeline` | Advanced features |
| **Help** | `help`, `version` | Information |

## Quick Start Sequence

```bash
# 1. Initialize project
make start NAME="MyProject" DESC="Project description"

# 2. Add documents to workspace/incoming/

# 3. Generate plan
make fix

# 4. Create focus list
make work

# 5. Complete session
make done
```

**Total Commands:** 47 commands across 12 categories