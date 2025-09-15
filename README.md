# 🚀 HelmStack Community Edition

[![Version](https://img.shields.io/badge/HelmStack-v2.1.0--community-blue.svg)](https://github.com/raufA1/HelmStack)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/raufA1/HelmStack.svg)](https://github.com/raufA1/HelmStack/stargazers)

> **Document-first project management for open source teams**
>
> Transform scattered documents into actionable project plans with the power of structured workflows.

## ✨ What is HelmStack?

HelmStack is a document-first project management system that helps developers and teams:

- **🔄 Transform documents into actionable plans** - Drop docs in `workspace/incoming/`, get organized plans out
- **🎯 Focus on what matters** - Auto-generated focus lists from your project docs
- **📊 Track progress systematically** - Session-based workflow with built-in snapshots
- **🏗️ Integrate with GitHub seamlessly** - Repository setup, issue templates, and automation

**Perfect for:** Open source projects, documentation-heavy work, research projects, and teams that think in documents first.

## 🚀 Quick Start

### Installation

```bash
# 1. Clone HelmStack Community Edition
git clone https://github.com/raufA1/HelmStack.git MyProject
cd MyProject

# 2. Set up the hs command
alias hs="make -f Helmfile"

# 3. Initialize your project
hs start

# 4. See what's possible
hs help
```

### Basic Workflow

```bash
# Daily workflow - just 3 commands!
hs fix    # 🧭 Refresh plans from documents
hs work   # 🎯 Create focus list
hs done   # ✅ Complete session

# Check your progress
hs status # 📊 Current project status
hs focus  # 🎯 Today's focus items
```

## 📁 How It Works

### 1. **Document-First Approach**
```
workspace/
├── incoming/     # 📥 Drop your docs here (any format)
├── plans/        # 📋 Generated STATUS.md, NEXT_STEPS.md
└── research/     # 🔬 Research and findings
```

### 2. **Structured Workflow**
```bash
hs start  # 🔥 Set up project structure
hs fix    # 🧭 Analyze docs → generate plans
hs work   # 🎯 Extract focus list from plans
hs done   # ✅ Create session snapshot
```

### 3. **GitHub Integration**
```bash
hs repo NAME="MyProject" DESC="Description"  # Create GitHub repo
hs publish                                   # Push to GitHub
hs setup                                     # Configure labels & templates
```

## 🛠️ Core Features

### 📊 Project Management
- **Document Analysis** - Basic parsing and organization
- **Plan Generation** - STATUS.md and NEXT_STEPS.md creation
- **Focus Lists** - Daily prioritization from your plans
- **Session Snapshots** - Track progress over time

### 🏗️ GitHub Integration
- **Repository Creation** - `hs repo` command
- **Template System** - Issue and PR templates
- **ADR Support** - Architecture Decision Records
- **Automation Setup** - Labels, milestones, workflows

### 🔧 Development Tools
- **Environment Health Check** - `hs doctor` diagnostics
- **Interactive Demo** - `hs demo` for new users
- **Template Generator** - Custom templates for any workflow
- **Pre-commit Integration** - Code quality automation

## 📖 Commands Reference

### Core Workflow
| Command | Description | Example |
|---------|-------------|---------|
| `hs start` | Initialize project | `hs start` |
| `hs fix` | Refresh plans | `hs fix` |
| `hs work` | Create focus list | `hs work` |
| `hs done` | Complete session | `hs done` |

### GitHub Integration
| Command | Description | Example |
|---------|-------------|---------|
| `hs repo` | Create GitHub repo | `hs repo NAME="MyProject"` |
| `hs publish` | Push to GitHub | `hs publish` |
| `hs setup` | Configure GitHub features | `hs setup` |

### Templates & Docs
| Command | Description | Example |
|---------|-------------|---------|
| `hs template` | Generate templates | `hs template TYPE=issue FILE=bug.md` |
| `hs adr-new` | Create ADR | `hs adr-new TITLE="Use PostgreSQL"` |

### Status & Info
| Command | Description | Example |
|---------|-------------|---------|
| `hs status` | Show project status | `hs status` |
| `hs focus` | Show focus list | `hs focus` |
| `hs doctor` | Environment check | `hs doctor` |
| `hs help` | Show all commands | `hs help` |

## 🎯 Example Workflow

```bash
# 1. Start a new project
mkdir MyAwesomeProject && cd MyAwesomeProject
hs init NAME="MyAwesome" DESC="An awesome open source project"

# 2. Add some documents
echo "# Project Vision\nBuild something amazing..." > workspace/incoming/vision.md
echo "# Requirements\n- Feature A\n- Feature B" > workspace/incoming/requirements.md

# 3. Generate your first plan
hs fix
# ✅ Created: workspace/plans/STATUS.md
# ✅ Created: workspace/plans/NEXT_STEPS.md

# 4. Create focus list for today
hs work
# ✅ Created: workspace/plans/FOCUS_LIST.md

# 5. Check what to focus on
hs focus
# 🎯 Today's Focus:
# - [ ] Set up basic project structure
# - [ ] Define core requirements
# - [ ] Create initial documentation

# 6. End your session
hs done
# ✅ Session snapshot saved: snapshots/snap-2024-01-15-14-30.txt
```

## ✨ Upgrade to HelmStack Pro

Love HelmStack Community Edition? **HelmStack Pro** supercharges your productivity with:

### 🤖 AI-Powered Features
- **Smart Document Analysis** - AI extracts epics, milestones, and tasks
- **Intelligent Commit Messages** - Context-aware git commits
- **Memory Management** - AI remembers your project context across sessions

### 📊 Advanced Analytics
- **Productivity Dashboard** - Comprehensive metrics and insights
- **Trend Analysis** - Track your productivity patterns over time
- **Session Comparisons** - Visual diffs between work sessions

### 🔎 Research Automation
- **Human-in-the-Loop Research** - `ask/check/yes/no/end` workflow
- **Document Conversion** - PDF/DOCX to structured Markdown
- **Advanced Analyzers** - Risk assessment, scope analysis, dependencies

### ⚡ Advanced Automation
- **Project Automation** - Smart workflows and triggers
- **GitHub Project Integration** - Automatic board updates
- **Self-Update System** - Stay current with latest features

**[Learn More About HelmStack Pro →](https://helmstack.dev/pro)**

## 🤝 Contributing

We love contributions! HelmStack Community Edition is open source and welcomes:

- 🐛 **Bug Reports** - Found an issue? [Open an issue](https://github.com/raufA1/HelmStack/issues)
- 💡 **Feature Requests** - Have an idea? [Start a discussion](https://github.com/raufA1/HelmStack/discussions)
- 🔧 **Pull Requests** - Want to help? Check our [contributing guide](CONTRIBUTING.md)
- 📚 **Documentation** - Improve our docs and examples

### Development Setup

```bash
git clone https://github.com/raufA1/HelmStack.git
cd HelmStack
./scripts/doctor.sh  # Check environment
./scripts/demo.sh    # Try the interactive demo
```

## 📋 Requirements

- **Git** - Version control
- **Bash** - Shell scripting (available on macOS, Linux, Windows/WSL)
- **GitHub CLI** (optional) - For GitHub integration features
- **Pre-commit** (optional) - For code quality hooks

Run `hs doctor` to check your environment!

## 🗺️ Roadmap

### Community Edition
- [ ] Enhanced template system
- [ ] Basic workflow automation
- [ ] Multi-language support
- [ ] Plugin architecture
- [ ] Web UI (read-only)

### HelmStack Pro
- [ ] Advanced AI integrations
- [ ] Real-time collaboration
- [ ] Enterprise SSO
- [ ] SaaS hosting option
- [ ] Mobile companion app

## 📄 License

HelmStack Community Edition is MIT licensed. See [LICENSE](LICENSE) for details.

## 🙏 Acknowledgments

Built with love by the HelmStack team. Special thanks to:

- The open source community for inspiration and feedback
- Contributors who help make HelmStack better
- Early adopters who believed in document-first workflows

## 🔗 Links

- **Website:** [helmstack.dev](https://helmstack.dev)
- **Documentation:** [docs.helmstack.dev](https://docs.helmstack.dev)
- **Community:** [Discussions](https://github.com/raufA1/HelmStack/discussions)
- **Pro Edition:** [helmstack.dev/pro](https://helmstack.dev/pro)
- **Support:** [GitHub Issues](https://github.com/raufA1/HelmStack/issues)

---

<div align="center">

**⭐ Star this repo if HelmStack helps you!**

**[Try HelmStack Pro](https://helmstack.dev/pro)** • **[Join Community](https://github.com/raufA1/HelmStack/discussions)** • **[Contribute](CONTRIBUTING.md)**

*Made with ❤️ for document-driven teams*

</div>