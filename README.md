# HelmStack 🚀

> **A single, elastic repository that plans, tracks, and orchestrates work like a professional PM**

[![GitHub](https://img.shields.io/badge/GitHub-raufA1%2FHelmStack-blue)](https://github.com/raufA1/HelmStack)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Version](https://img.shields.io/badge/Version-1.0.0--M5-orange.svg)](CHANGELOG.md)
[![CI](https://github.com/raufA1/HelmStack/actions/workflows/ci.yml/badge.svg)](https://github.com/raufA1/HelmStack/actions/workflows/ci.yml)
[![Pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](.pre-commit-config.yaml)
[![Commands](https://img.shields.io/badge/Commands-47-blue.svg)](COMMANDS.md)
[![Python](https://img.shields.io/badge/Python-3.8%2B-blue.svg)](scripts/)
[![Shell](https://img.shields.io/badge/Shell-Bash-green.svg)](scripts/)

HelmStack transforms any set of documents into actionable plans with **document-first**, **repo-as-memory**, and **human-in-the-loop** research workflows.

## ✨ Key Features

- 📋 **Document-First Planning**: Turn any docs into actionable plans
- 🧠 **Repo-as-Memory**: Persistent memory inside the repository
- 🔬 **Human-in-the-Loop Research**: Structured decision making
- 🔍 **Pluggable Analyzers**: Risk, scope, and complexity analysis
- 📊 **Session Analytics**: Track productivity and trends
- 📝 **Architecture Decision Records**: Structured decision tracking
- 🤖 **35+ Commands**: Complete project management workflow

## 🚀 Quick Start

### 1. Setup New Project
```bash
# Clone or use template
git clone git@github.com:raufA1/HelmStack.git myproject
cd myproject

# Initialize with your documents
make start NAME="MyProject" DESC="One-liner description" DOC=spec.md
```

### 2. Daily Workflow
```bash
# Morning: Generate plan from documents
make fix                    # Create STATUS.md, NEXT_STEPS.md
make work                   # Build FOCUS_LIST.md

# During work: Research workflow
make ask TOPIC="Which database to use?"
# Edit research files, then:
make check                  # Review findings
make yes                    # Approve → adds to NEXT_STEPS

# End of day: Snapshot and analytics
make done                   # Commit, tag, push, analytics
make analytics             # View productivity metrics
```

### 3. Advanced Features
```bash
# Document analysis
make analyze PATH=workspace/incoming     # Multi-analyzer pipeline
make epics                              # Extract epics from docs
make milestones                         # Extract milestones

# Architecture decisions
make adr-new TITLE="Use PostgreSQL"     # Create decision record
make adr-accept NUM=001                  # Accept decision

# Productivity tracking
make trends DAYS=7                       # 7-day productivity trends
```

## 📁 Directory Structure

```
helmstack/
├─ 📋 Makefile                    # 35+ commands
├─ 📄 README.md                   # This file
├─ 📜 COMMANDS.md                 # Complete command reference
├─ 🔧 scripts/                    # All automation
│  ├─ 🔍 analyzers/              # Pluggable analyzers
│  ├─ 📊 analytics.py            # Session analytics
│  ├─ 📋 adr.sh                  # Architecture decisions
│  └─ 📝 templates.sh            # Template generator
├─ 📁 workspace/
│  ├─ 📥 incoming/               # Your source documents
│  ├─ 📋 plans/                  # Generated plans
│  ├─ 🔬 research/               # Research threads
│  └─ 📦 processed/              # Archived inputs
├─ 🧠 memory/                     # Persistent memory
│  ├─ 📝 SUMMARY.md              # Project summary
│  ├─ ⚖️  DECISIONS.md            # Decision log
│  └─ ❓ OPEN_QUESTIONS.md       # Questions tracker
├─ 📸 snapshots/                  # EOD snapshots
└─ 📝 templates/                  # Document templates
```

## 🔄 Core Workflow

### 1. Document Processing Pipeline
```bash
docs → incoming/ → run_analyzer.sh → plans/ → FOCUS_LIST → work
```

### 2. Research Loop (Human-in-the-Loop)
```bash
ask → research/ → check → yes/no → NEXT_STEPS/changes → end
```

### 3. Memory Management
```bash
every fix/work/done → ai_memory_refresh.sh → memory/SUMMARY.md
```

### 4. Analytics Pipeline
```bash
snapshots/ → analytics.py → productivity metrics → trends
```

## 🔍 Analyzers

HelmStack includes pluggable analyzers for different aspects:

| Analyzer | Purpose | Key Metrics |
|----------|---------|-------------|
| **markdown** | Extract tasks, epics, decisions | Tasks, headings, complexity |
| **risk** | Identify risks and blockers | Risk score, dependencies |
| **scope** | Estimate complexity and effort | Scope size, effort estimation |

### Custom Analyzers
Create your own by extending `BaseAnalyzer`:

```python
from analyzers.base_analyzer import BaseAnalyzer

class CustomAnalyzer(BaseAnalyzer):
    def analyze(self, content, file_path):
        return {
            'tasks': [...],
            'risks': [...],
            'metrics': {...}
        }
```

## 📊 Session Analytics

Track your productivity with detailed metrics:

- **Productivity Score**: 0-10 based on changes, file diversity, commits
- **Focus Areas**: Automatically detected from file changes
- **Time Tracking**: Session duration and work patterns
- **Trends**: 7-day moving averages and improvement tracking

```bash
make analytics    # Today's session
make trends       # 7-day trends
make trends DAYS=30  # Custom period
```

## 📋 Architecture Decision Records (ADR)

Structure your technical decisions:

```bash
make adr-new TITLE="Use PostgreSQL for database"
# Edit the generated ADR with context, decision, consequences
make adr-accept NUM=001
```

ADR lifecycle: `Proposed → Accepted/Rejected → Superseded`

## 📝 Templates

Generate structured documents:

| Template | Purpose | Command |
|----------|---------|---------|
| **issue** | GitHub issues | `make template TYPE=issue FILE=bug.md` |
| **todo** | TODO blocks | `make template TYPE=todo FILE=tasks.md` |
| **research** | Research proposals | `make template TYPE=research FILE=study.md` |
| **epic** | Epic specifications | `make template TYPE=epic FILE=feature.md` |

## 🚀 GitHub Integration

Bootstrap your repository:

```bash
make setup  # Creates labels, milestones, issue templates
```

**Created automatically:**
- 🏷️ **Labels**: ready, blocked, epic, urgent, high-priority, research, task, bug, enhancement, documentation
- 🏆 **Milestones**: M1-M4 with due dates
- 📝 **Issue Templates**: bug_report, feature_request, task, research

## 🛠 Installation & Setup

### Prerequisites
- Git
- Python 3.8+
- Make
- Optional: `gh` CLI for GitHub integration

### From Template (Recommended)
1. Click **"Use this template"** on GitHub
2. Clone your new repository
3. Run `make start NAME="YourProject" DESC="Description"`

### From Scratch
```bash
git clone git@github.com:raufA1/HelmStack.git
cd HelmStack
make start NAME="YourProject" DESC="Description"
```

### Dependencies
```bash
# Optional: For PDF/DOCX support
pip install python-docx PyPDF2

# Optional: For advanced pre-commit
pip install pre-commit
pre-commit install
```

## 📚 Examples

### 1. Software Project
```bash
make start NAME="TaskApp" DESC="Personal task manager"
# Add specs to workspace/incoming/
make fix work  # Generate plan and focus list
```

### 2. Research Project
```bash
make start NAME="MLStudy" DESC="Machine learning research"
make ask TOPIC="Which algorithm performs better?"
# Research and document findings
make yes  # Approve and add to next steps
```

### 3. Team Project
```bash
make setup  # GitHub integration
make adr-new TITLE="API Authentication Strategy"
# Team reviews and decides
make adr-accept NUM=001
```

## 🔧 Configuration

### Environment Variables
```bash
export HELMSTACK_ANALYZER=markdown,risk,scope  # Default analyzers
export HELMSTACK_MEMORY_REFRESH=auto           # Auto memory refresh
```

### Makefile Variables
```bash
make analyze PATH=docs ANALYZER=risk  # Custom analyzer
make trends DAYS=14                   # Custom period
```

## 📈 Advanced Usage

### 1. Multi-Repository Setup
```bash
# Central HelmStack for organization
git submodule add git@github.com:raufA1/HelmStack.git .helmstack
cd .helmstack && make start NAME="OrgProjects"
```

### 2. Custom Workflows
```bash
# Morning routine
alias morning="make fix && make work && make analytics"

# Evening routine
alias evening="make done && make trends"
```

### 3. Team Collaboration
```bash
# Research collaboration
make ask TOPIC="Architecture decisions"
# Team members add notes to research/*/notes.md
make check  # Review all inputs
make yes    # Team consensus → next steps
```

## 🤝 Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/amazing-feature`
3. Make changes and test: `make analyze PATH=.`
4. Commit: `git commit -m "feat: add amazing feature"`
5. Push: `git push origin feature/amazing-feature`
6. Open Pull Request

### Development Setup
```bash
git clone git@github.com:raufA1/HelmStack.git
cd HelmStack
make start NAME="HelmStack-Dev" DESC="Development environment"
# Test your changes
make analyze PATH=workspace/incoming
```

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🆘 Support

- 📖 [Documentation](docs/)
- 📋 [Commands Reference](COMMANDS.md)
- 🐛 [Issue Tracker](https://github.com/raufA1/HelmStack/issues)
- 💬 [Discussions](https://github.com/raufA1/HelmStack/discussions)

## 🎯 Roadmap

- [x] **M1**: Core planning pipeline ✅
- [x] **M2**: Epic extraction, templates, GitHub bootstrap ✅
- [x] **M3**: Pluggable analyzers, ADR system, session analytics ✅
- [ ] **M4**: Extensive docs, CI hardening, migration guides
- [ ] **Future**: Web UI, API, integrations

---

> **"Steer your work with a reliable stack"** - HelmStack makes project management systematic, measurable, and sustainable.