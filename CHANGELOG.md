# Changelog

All notable changes to HelmStack will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Clean template artifacts for better distribution
- Normalized ADR folder structure (`docs/adr/`)
- Comprehensive CHANGELOG.md with badges
- Template repository cleanup improvements

### Fixed
- ADR path references updated throughout codebase
- Release artifact exclusions improved

## [1.0.0-M5] - 2024-09-14

### Added
- **Command Orchestration**: 47 total commands across 12 categories
- **Advanced AI Memory System**: Comprehensive summaries with MEMORY.md and CONTEXT.md
- **Resilience & UX**: Colorful help system with emoji organization
- **GitHub Integration**: `gh-create`, `gh-push`, `pr` commands
- **Future-proof Extensions**: `analyzers`, `productivity`, `timeline` commands
- **Pre-commit Integration**: `fix-lint`, `fix-format`, `fix-yaml` commands
- **Safe Git Operations**: Handles no-HEAD state gracefully
- **Automated Directory Setup**: `make start` creates complete workspace structure
- **Enhanced EOD Workflow**: Automatic commit/tag/push with session snapshots

### Changed
- **Memory System**: Complete refactor for comprehensive project summaries
- **Help System**: Color-coded with ANSI colors and emoji categorization
- **Error Handling**: Graceful degradation when tools are missing

### Fixed
- Pre-commit hook compatibility with shellcheck
- YAML formatting in CI/CD workflows
- Script permissions set automatically

## [1.0.0-M4] - 2024-09-14

### Added
- **Extensive Documentation**: GETTING_STARTED.md, MIGRATION_GUIDE.md
- **CI Hardening**: Multi-stage validation pipeline
- **Release Automation**: Automated release workflow
- **Examples**: Personal and software project examples
- **Template Repository**: Complete setup for new users
- **MIT License**: Open source licensing

### Changed
- Pre-commit hooks updated for better code quality
- CI/CD pipeline with security scanning

## [1.0.0-M3] - 2024-09-14

### Added
- **Pluggable Analyzers**: Extensible document analysis system
- **Architecture Decision Records (ADR)**: Structured decision tracking
- **Session Analytics**: Productivity metrics and trends
- **Risk Analysis**: Automated risk and blocker detection
- **Base Analyzer System**: Abstract classes for extensibility

### Changed
- Analyzer architecture redesigned for pluggability
- Analytics system enhanced with real metrics

## [1.0.0-M2] - 2024-09-14

### Added
- **Epic Extraction**: Automated epic identification from documents
- **Template System**: Dynamic template generation
- **GitHub Integration**: Repository bootstrap and management
- **Milestone Extraction**: Project milestone identification
- **Enhanced Task Extraction**: Better heading-to-task conversion

### Changed
- CLI prompts improved for better user experience
- GitHub integration streamlined

## [1.0.0-M1] - 2024-09-14

### Added
- **Core Workflow**: `start`, `fix`, `work`, `done` command sequence
- **Document-to-Plan Pipeline**: Automatic plan generation from documents
- **Focus Extraction**: Priority-based task lists
- **Research Workflow (HITL)**: Human-in-the-loop research system
- **Session Management**: End-of-day snapshots with git integration
- **AI Memory System**: Repository-based memory management
- **Makefile Interface**: Command orchestration system
- **Workspace Structure**: Organized directory hierarchy
- **Basic Analytics**: Session tracking and metrics

### Technical
- Python-based analyzer system
- Bash script automation
- Git-native architecture
- Markdown-first approach

---

## Release Types

- **Major**: Breaking changes, new architecture
- **Minor**: New features, backwards compatible
- **Patch**: Bug fixes, documentation updates
- **Milestone (M)**: Development phases during pre-release

## Development Phases

- **M1 (Foundation)**: Core workflow and basic features
- **M2 (Enhancement)**: Templates and integrations
- **M3 (Intelligence)**: AI features and analytics
- **M4 (Production)**: Documentation and CI/CD
- **M5 (Stabilization)**: Polish and robustness
- **v1.0.0**: Production release

## Links

- [GitHub Repository](https://github.com/raufA1/HelmStack)
- [Documentation](docs/)
- [Issue Tracker](https://github.com/raufA1/HelmStack/issues)
- [Releases](https://github.com/raufA1/HelmStack/releases)