# HelmStack Community Edition

Open source project orchestration and workflow automation toolkit. This is the community edition of HelmStack, providing essential project management tools and workflow templates.

## Features

- **Project Templates**: Ready-to-use project structures and workflows
- **Basic Automation**: Essential workflow automation tools
- **Documentation Tools**: Project documentation and status tracking
- **Community Workflows**: Shared workflows and best practices
- **Integration Examples**: Basic integrations with popular tools

## Quick Start

```bash
# Install HelmStack Community Edition
git clone https://github.com/your-org/helmstack.git
cd helmstack

# Initialize a new project
./bin/hs init myproject

# Use basic workflows
./bin/hs workflow list
./bin/hs workflow run basic-setup

# Generate project documentation
./bin/hs docs generate
```

## Available Workflows

### Project Setup
- **basic-setup**: Initialize basic project structure
- **git-flow**: Set up Git workflow with branches and hooks
- **docs-template**: Create documentation template
- **ci-basic**: Basic CI/CD pipeline setup

### Documentation
- **readme-template**: Generate comprehensive README
- **changelog**: Automated changelog generation
- **api-docs**: API documentation templates
- **project-status**: Status reporting templates

### Development
- **code-review**: Code review workflow templates
- **testing-setup**: Testing framework setup
- **deployment-basic**: Basic deployment workflows
- **monitoring**: Basic monitoring and alerting

## Templates

### Project Templates
```
templates/
├── web-app/           # Web application template
├── api-service/       # REST API service template
├── library/           # Library/package template
├── documentation/     # Documentation site template
└── microservice/      # Microservice template
```

### Workflow Templates
```
workflows/
├── ci-cd/            # CI/CD pipeline templates
├── deployment/       # Deployment workflows
├── testing/          # Testing workflows
├── documentation/    # Documentation workflows
└── monitoring/       # Monitoring workflows
```

## Examples

### Basic Project Setup
```bash
# Create new project from template
hs template create web-app my-web-app

# Set up Git workflow
cd my-web-app
hs workflow run git-flow

# Generate documentation
hs docs generate
```

### Workflow Automation
```bash
# List available workflows
hs workflow list

# Run workflow with parameters
hs workflow run ci-basic --platform github

# Create custom workflow
hs workflow create my-custom-workflow
```

### Status Tracking
```bash
# Generate project status
hs status

# Create status report
hs status --format markdown > STATUS.md

# Track project metrics
hs metrics collect
```

## Community

- **GitHub**: https://github.com/your-org/helmstack
- **Discussions**: https://github.com/your-org/helmstack/discussions
- **Issues**: https://github.com/your-org/helmstack/issues
- **Wiki**: https://github.com/your-org/helmstack/wiki

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Pro Edition

For advanced features including AI-powered automation, enterprise integrations, and professional support, check out [HelmStack Pro Edition](https://helmstack.dev/pro).

### Pro Features
- 🤖 **AI-Powered Planning**: Intelligent project planning and task prioritization
- 🔗 **Advanced Integrations**: GitHub, Slack, JIRA, and custom API connectors
- 📊 **Analytics Dashboard**: Comprehensive project insights and reporting
- 🚀 **Automated Workflows**: Advanced automation with custom triggers
- 🎯 **Smart Recommendations**: AI-driven optimization suggestions
- 👥 **Team Collaboration**: Advanced team features and permissions
- 🛠️ **Custom Addons**: Extensible plugin architecture
- 🔒 **Enterprise Security**: SSO, audit logs, compliance features

## Architecture

```
HelmStack Community Edition
├── Core Engine (Open Source)
│   ├── Project Templates
│   ├── Basic Workflows
│   ├── Documentation Tools
│   └── Status Tracking
├── Templates Library
│   ├── Project Types
│   ├── Workflow Templates
│   └── Integration Examples
└── Community Features
    ├── Shared Workflows
    ├── Best Practices
    └── Contribution Tools
```

## License

MIT License - see [LICENSE](LICENSE) for details.

## Ecosystem

- **helmstack**: Community Edition (this repository)
- **helmstack-templates**: Additional templates and examples
- **helmstack-docs**: Documentation and guides
- **helmstack-examples**: Real-world usage examples

---

**HelmStack Community Edition** - Open source project orchestration for everyone.