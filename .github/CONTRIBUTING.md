# 🤝 Contributing to HelmStack

Thank you for your interest in contributing to HelmStack! This guide will help you get started.

## 🚀 Quick Start

1. **Fork & Clone**: Fork the repository and clone your fork
2. **Setup**: Run `hs start NAME="YourContribution" DESC="Description"`
3. **Install**: Run `pre-commit install` to set up hooks
4. **Develop**: Make your changes following our guidelines
5. **Test**: Ensure all tests pass and pre-commit hooks succeed
6. **Submit**: Create a pull request with a clear description

## 🛠️ Development Environment

### Prerequisites
- Python 3.8+
- Git
- Make/Bash
- Optional: `gh` CLI for GitHub integration

### Setup
```bash
git clone git@github.com:YOUR_USERNAME/HelmStack.git
cd HelmStack
alias hs="make -f Helmfile"
hs start NAME="HelmStack-Dev" DESC="Development environment"
pre-commit install
```

## 📋 Development Guidelines

### Code Style
- **Python**: Black formatting, ruff linting
- **Shell**: Shellcheck compliance
- **YAML**: yamllint compliance
- **Documentation**: Clear, concise, example-driven

### Commit Messages
Follow conventional commits format:
- `feat:` new features
- `fix:` bug fixes
- `docs:` documentation changes
- `chore:` maintenance tasks
- `refactor:` code restructuring

### Testing
- All scripts must be tested with sample data
- Analyzers must have unit tests
- Pre-commit hooks must pass
- Manual testing with edge cases

## 🎯 Ways to Contribute

### 🐛 Bug Reports
- Use the bug report template
- Include reproduction steps
- Provide environment details
- Test with latest version

### ✨ Feature Requests
- Use the feature request template
- Align with document-first philosophy
- Include user stories and acceptance criteria
- Consider backward compatibility

### 📚 Documentation
- Fix typos and clarify confusing sections
- Add examples and use cases
- Update command references
- Improve setup instructions

### 🔧 Code Contributions
- **Analyzers**: Add support for new document formats
- **Scripts**: Improve workflow automation
- **Templates**: Add new project templates
- **GitHub Integration**: Enhance repository management

## 🏗️ Architecture Guidelines

### Adding New Analyzers
1. Extend `BaseAnalyzer` class
2. Implement required methods
3. Add to analyzer manager
4. Include tests and documentation

### Adding New Commands
1. Add to Helmfile (hs runner)
2. Maintain Makefile compatibility
3. Update help system
4. Document in COMMANDS.md

### Modifying Core Workflows
1. Maintain backward compatibility
2. Update all affected documentation
3. Test with existing projects
4. Consider migration paths

## 🔍 Review Process

### Pull Request Guidelines
- Use the PR template
- Link to related issues
- Include clear change description
- Add tests for new functionality
- Update documentation as needed

### Review Criteria
- Code quality and style compliance
- Functionality and correctness
- Documentation completeness
- Test coverage
- Backward compatibility
- Security considerations

## 🎨 Design Philosophy

When contributing, keep these principles in mind:

1. **Document-First**: Solutions should work with natural documentation
2. **Progressive Enhancement**: Simple by default, powerful when needed
3. **Git-Native**: Leverage git for versioning and collaboration
4. **Tool Agnostic**: Work with any editor or development environment
5. **Human-in-the-Loop**: AI assists, humans decide

## 🏷️ Issue Labels

- `priority: high/medium/low` - Priority level
- `type: bug/feature/docs/infra` - Change type
- `good first issue` - Beginner friendly
- `help wanted` - Community input needed
- `epic` - Large feature sets
- `research` - Investigation required

## 📞 Getting Help

- 💬 [GitHub Discussions](https://github.com/raufA1/HelmStack/discussions)
- 📖 [Documentation](README.md)
- 🐛 [Issue Tracker](https://github.com/raufA1/HelmStack/issues)

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Happy contributing! 🎉**