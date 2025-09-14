# 📋 HelmStack Commands Reference (hs runner)

Complete reference for all HelmStack commands using the **hs runner** interface.

> **Setup:** Add `alias hs="hs-f Helmfile"` to your shell profile for the recommended hs experience.

## 🚀 Core Workflow

### `hs start`
**Initialize new project with complete workspace structure**
```bash
hs start NAME="ProjectName" DESC="Project description"
```
- Creates all necessary directories (`workspace/`, `memory/`, `snapshots/`)
- Sets up git repository if needed
- Installs pre-commit hooks
- Generates initial project document
- **Alias:** `hs go`

### `hs fix`
**Refresh project plan from documents**
```bash
hs fix
```
- Analyzes all documents in `workspace/incoming/`
- Generates `STATUS.md` and `NEXT_STEPS.md`
- Refreshes AI memory system
- **Alias:** `hs plan`

### `hs work`
**Generate focus list from next steps**
```bash
hs work
```
- Extracts top priorities from `NEXT_STEPS.md`
- Creates `FOCUS_LIST.md` for daily work
- Updates memory with current focus

### `hsdone`
**Complete session with snapshot and git operations**
```bash
hsdone
```
- Creates timestamped snapshot
- Commits all changes
- Creates session tag
- Pushes to remote (if configured)
- Handles repos with no HEAD safely

## 📄 Document Analysis

### `hsanalyze`
**Analyze documents with pluggable analyzers**
```bash
hsanalyze PATH=workspace/incoming
hsanalyze PATH=specific-file.md
```
- Uses all available analyzers
- Extracts tasks, epics, risks, metrics
- Supports markdown, PDF, DOCX formats

### `hsepics`
**Extract project epics from documents**
```bash
hsepics
```
- Identifies major project themes
- Groups related tasks
- Generates `EPICS.md`

### `hsmilestones`
**Extract project milestones**
```bash
hsmilestones
```
- Identifies key project checkpoints
- Creates timeline structure

### `hsideas`
**Extract ideas and suggestions**
```bash
hsideas
```
- Captures innovative thoughts
- Identifies improvement opportunities

### `hsrisks`
**Analyze risks and blockers**
```bash
hsrisks
```
- Identifies potential problems
- Assesses severity levels
- Generates risk mitigation suggestions

### `hsblockers`
**Show current blockers**
```bash
hsblockers
```
- Lists immediate obstacles
- Shows blocker severity
- Creates `BLOCKERS.md`

## 🧠 AI Memory System

### `hsmemory`
**Show comprehensive AI memory summary**
```bash
hsmemory
```
- Displays complete project state
- Includes all workspace analysis
- Shows recent decisions and progress

### `hscontext`
**Show quick context for current session**
```bash
hscontext
```
- Provides immediate next steps
- Shows key file locations
- Optimized for quick reference

### `hsrefresh`
**Manually refresh AI memory**
```bash
hsrefresh
```
- Updates memory from all workspace files
- Rebuilds comprehensive summary
- **Alias:** Called automatically by other commands

## 🔍 Research Workflow (HITL)

### `hsask`
**Start research thread**
```bash
hsask TOPIC="Research question"
```
- Initiates human-in-the-loop research
- Creates research workspace
- Documents research question

### `hscheck`
**Review research findings**
```bash
hscheck
```
- Summarizes research results
- Presents findings for approval
- Prepares decision point

### `hsyes`
**Approve research proposal**
```bash
hsyes
```
- Accepts research findings
- Integrates into project plans
- Updates next steps

### `hsno`
**Request research changes**
```bash
hsno
```
- Rejects current findings
- Requests additional research
- Maintains research thread

### `hsend`
**Complete research thread**
```bash
hsend
```
- Closes research session
- Archives findings
- Updates project memory

## 📊 Analytics & Metrics

### `hsanalytics`
**Session productivity analytics**
```bash
hsanalytics
```
- Shows current session metrics
- Analyzes file changes
- Calculates productivity scores

### `hstrends`
**Productivity trends over time**
```bash
hstrends DAYS=7
hstrends DAYS=30
```
- Shows productivity patterns
- Identifies work cycles
- Default: 7 days

### `hsproductivity`
**Real productivity metrics**
```bash
hsproductivity
```
- Git commit analysis
- TODO completion rates
- Session efficiency metrics

### `hstimeline`
**Project timeline**
```bash
hstimeline
```
- Git commit history
- Visual project evolution
- Key milestone markers

### `hssnapshot`
**Create session snapshot**
```bash
hssnapshot
```
- Captures current state
- Documents session progress
- Creates timestamped record

## 🏗️ Architecture Decisions (ADR)

### `hsadr-new`
**Create new Architecture Decision Record**
```bash
hsadr-new TITLE="Decision title"
```
- Creates numbered ADR file
- Uses standard ADR template
- Tracks decision context

### `hsadr-list`
**List all ADRs**
```bash
hsadr-list
```
- Shows all decisions
- Displays status (Proposed/Accepted/Rejected)
- Ordered by creation date

### `hsadr-accept`
**Accept ADR**
```bash
hsadr-accept ID=001
```
- Marks ADR as accepted
- Updates decision status
- Integrates into project plans

### `hsadr-reject`
**Reject ADR**
```bash
hsadr-reject ID=001
```
- Marks ADR as rejected
- Documents rejection reasons
- Maintains decision history

## 📝 Templates & Tools

### `hstemplate`
**Generate templates**
```bash
hstemplate TYPE=todo FILE=tasks.md
hstemplate TYPE=spec FILE=requirements.md
hstemplate TYPE=adr FILE=decision.md
```
- Creates structured templates
- Supports multiple template types
- Customizable content

### `hstemplates`
**List available templates**
```bash
hstemplates
```
- Shows all template types
- Displays usage examples

### `hsextract`
**Extract text from binary documents**
```bash
hsextract FILE=document.pdf OUTPUT=document.md
hsextract FILE=document.docx OUTPUT=document.md
```
- Converts PDF/DOCX to markdown
- Preserves document structure
- Enables document analysis

## 🔧 Status & Management

### `hsstatus`
**Show current project status**
```bash
hsstatus
```
- Displays `STATUS.md` content
- Shows project health
- Key metrics overview

### `hsnext`
**Show next steps**
```bash
hsnext
```
- Displays `NEXT_STEPS.md`
- Priority-ordered tasks
- Action items list

### `hsfocus`
**Show current focus list**
```bash
hsfocus
```
- Displays `FOCUS_LIST.md`
- Today's priorities
- Actionable items only

### `hsclean`
**Clean generated files**
```bash
hsclean
```
- Removes temporary snapshots
- Cleans focus lists
- Preserves source documents

### `hslog`
**Show session log**
```bash
hslog
```
- Recent session activity
- Change history
- Activity timeline

## 🔗 Git & GitHub Integration

### `hscommit`
**Commit with message**
```bash
hscommit MSG="Commit message"
```
- Commits all changes
- Requires commit message
- Adds all modified files

### `hspush`
**Push to remote**
```bash
hspush
```
- Pushes commits and tags
- Safe operation (continues on failure)

### `hsgh-create`
**Create GitHub repository**
```bash
hsgh-create NAME="repo-name" DESC="Description" PRIVATE=true
```
- Creates GitHub repository
- Adds SSH remote
- Configures for push

### `hsgh-push`
**Initial push to GitHub**
```bash
hsgh-push
```
- First push to GitHub
- Sets up tracking branch

### `hspr`
**Create Pull Request**
```bash
hspr TITLE="PR Title" BODY="PR Description"
```
- Creates GitHub Pull Request
- Uses GitHub CLI

### `hssetup`
**Bootstrap GitHub integration**
```bash
hssetup
```
- Complete GitHub setup
- Repository creation
- Initial configuration

## 🛠️ Development & Quality

### `hsfix-lint`
**Fix linting issues**
```bash
hsfix-lint
```
- Runs ruff with auto-fix
- Resolves code quality issues
- Python script linting

### `hsfix-format`
**Fix code formatting**
```bash
hsfix-format
```
- Runs black formatter
- Standardizes code style

### `hsfix-yaml`
**Fix YAML formatting**
```bash
hsfix-yaml
```
- Validates YAML files
- Checks workflow syntax

## 🔍 Advanced Analysis

### `hsanalyzers`
**List available analyzers**
```bash
hsanalyzers
```
- Shows pluggable analyzers
- Analyzer capabilities
- Usage information

### `hsdependencies`
**Dependency analysis**
```bash
hsdependencies
```
- Identifies project dependencies
- Creates dependency map
- Shows relationships

## 📖 Help & Information

### `hshelp`
**Show colorful help**
```bash
hshelp
```
- Complete command reference
- Color-coded by category
- Usage examples

### `hsversion`
**Show HelmStack version**
```bash
hsversion
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
hsstart NAME="MyProject" DESC="Project description"

# 2. Add documents to workspace/incoming/

# 3. Generate plan
hsfix

# 4. Create focus list
hswork

# 5. Complete session
hsdone
```

**Total Commands:** 47 commands across 12 categories