# 🏗️ HelmStack Architecture

## System Overview

HelmStack is built around a clean separation of concerns with pluggable components:

```
helmstack/
├── 📄 Core Config
│   ├── Helmfile              # hs runner interface (recommended)
│   ├── Makefile              # Legacy command orchestration
│   ├── .pre-commit-config.yaml # Code quality & security
│   └── .github/workflows/    # CI/CD automation
│
├── 🔧 Scripts & Logic
│   ├── scripts/
│   │   ├── analyzers/        # Pluggable document analyzers
│   │   ├── *.sh             # Bash workflow scripts
│   │   └── *.py             # Python processing tools
│   │
├── 📁 Workspace (All Working Files)
│   ├── incoming/             # Input documents
│   ├── processed/            # Archived/processed docs
│   ├── plans/               # Generated plans & status
│   └── research/            # HITL research findings
│
├── 🧠 Memory System
│   ├── memory/
│   │   ├── MEMORY.md         # AI comprehensive summary
│   │   ├── CONTEXT.md        # Quick context
│   │   └── decisions/        # ADR system
│   │
└── 📸 Session Tracking
    └── snapshots/            # End-of-day snapshots
```

## Core Pipelines

### 1. Document-to-Plan Pipeline
```
incoming/*.md → analyze.py → run_analyzer.sh → plans/STATUS.md, NEXT_STEPS.md
```

### 2. Focus Generation Pipeline
```
NEXT_STEPS.md → extract_next_steps.sh → FOCUS_LIST.md
```

### 3. AI Memory Pipeline
```
plans/* + research/* → ai_memory_refresh.sh → memory/MEMORY.md, CONTEXT.md
```

### 4. Research Workflow (HITL)
```
ask → research.sh → findings → check → [yes/no] → approved → plans/
```

### 5. Session Management
```
done → eod.sh → snapshot → git commit/tag/push
```

### 6. Analytics Pipeline
```
snapshots/*.txt + git log → analytics.py → productivity metrics
```

## Component Architecture

### Command Orchestration
**Helmfile (hs runner)** - Primary interface with enhanced GitHub integration:
- Core workflow: `hs start`, `hs fix`, `hs work`, `hs done`
- GitHub integration: `hs init`, `hs repo`, `hs publish`, `hs pr`
- Analysis: `hs analyze`, `hs epics`, `hs ideas`, `hs milestones`
- Memory: `hs memory`, `hs context`
- Research: `hs ask`, `hs check`, `hs yes`, `hs no`, `hs end`

**Makefile** - Legacy interface for backward compatibility (47 commands)

### Pluggable Analyzers
Base class system for document analysis:
- `base_analyzer.py` - Abstract interface
- `markdown_analyzer.py` - Main document processor
- `risk_analyzer.py` - Risk/blocker detection
- Extensible for new formats (PDF, DOCX, etc.)

### Memory System
AI-powered context management:
- Comprehensive summaries of all project state
- Quick context for immediate reference
- Decision tracking via ADR system
- Git-integrated session history

### Resilience Features
- Safe git operations (handles no-HEAD state)
- Graceful degradation when tools missing
- Color-coded help system
- Pre-commit hook integration

## Data Flow

1. **Input**: Documents placed in `workspace/incoming/`
2. **Processing**: Analyzers extract structure, tasks, risks
3. **Planning**: Generated plans in `workspace/plans/`
4. **Memory**: AI creates comprehensive summaries
5. **Action**: Focus list drives daily work
6. **Tracking**: Sessions captured in snapshots
7. **Evolution**: Git tracks all changes

## Design Principles

- **Document-Centric**: All project state derives from documents
- **Git-Native**: Leverages git for versioning and collaboration
- **Pluggable**: Analyzers and tools can be extended
- **Offline-First**: Works without internet/cloud dependencies
- **Human-Controlled**: AI suggests, humans decide
- **Progressive**: Start simple, add complexity as needed

## Integration Points

- **Git**: Version control, remote collaboration
- **GitHub**: Repository hosting, CI/CD, issues
- **Pre-commit**: Code quality gates
- **Python**: Analysis and AI processing
- **Bash**: System automation and workflow
- **Make**: Command orchestration