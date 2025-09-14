# HelmStack Examples

This directory contains real-world examples of using HelmStack for different types of projects.

## 📁 Example Projects

### 1. [Software Development](software-project/)
- Web application with React frontend and Node.js backend
- Shows epic extraction, ADR usage, and team collaboration
- **Files**: spec.md, architecture-decisions/, team-workflow.md

### 2. [Research Project](research-project/)
- Academic research with literature review and methodology
- Demonstrates research workflow and structured decisions
- **Files**: proposal.md, methodology.md, findings/

### 3. [Product Launch](product-launch/)
- Marketing campaign with multiple stakeholders
- Uses templates, milestones, and analytics tracking
- **Files**: launch-plan.md, marketing-strategy.md, timeline.md

### 4. [Personal Project](personal-project/)
- Simple side project setup
- Basic workflow demonstration
- **Files**: ideas.md, todo-list.md

## 🚀 Using Examples

### Method 1: Copy Example
```bash
cp -r examples/software-project/* workspace/incoming/
make fix work
```

### Method 2: Start from Example
```bash
# Clone HelmStack
git clone git@github.com:raufA1/HelmStack.git my-project
cd my-project

# Copy example files
cp examples/software-project/* workspace/incoming/

# Initialize
make start NAME="MyApp" DESC="Web application project"
make fix work
```

### Method 3: Learn from Structure
Browse the examples to understand:
- How to structure documents for best extraction
- ADR templates and decision processes
- Research workflow patterns
- Team collaboration approaches

## 📊 Example Outputs

Each example includes:
- **Input documents** - What you put in `workspace/incoming/`
- **Generated plans** - What HelmStack creates
- **Sample analytics** - Productivity metrics
- **ADR examples** - Architecture decisions
- **Research threads** - HITL workflow examples

## 📚 Learning Path

1. **Start with Personal Project** - Simplest example
2. **Try Software Project** - More complex with epics and ADRs
3. **Explore Research Project** - Academic/scientific workflow
4. **Scale to Product Launch** - Multi-stakeholder project

Each example builds on concepts from the previous ones.

## 🔄 Workflow Examples

### Daily Development Workflow
```bash
# Morning
make analytics              # Yesterday's productivity
make focus                 # Today's priorities

# During development
make ask TOPIC="API design decisions"
# ... research and document ...
make yes                   # Approve and add to next steps

# End of day
make done                  # Snapshot and analytics
```

### Team Collaboration Workflow
```bash
# Team lead
make adr-new TITLE="Database selection"
# Team fills out ADR collaboratively
make adr-accept NUM=001

# Research threads for complex decisions
make ask TOPIC="Performance optimization strategy"
# Multiple team members contribute to research/*/notes.md
make check                 # Review consolidated findings
make yes                   # Team consensus
```

### Project Planning Workflow
```bash
# Project kickoff
make start NAME="ProjectX" DESC="Description"
cp requirements.md workspace/incoming/
make fix                   # Generate initial plan

# Regular planning
make epics                 # Extract epic structure
make milestones           # Extract milestone timeline
make analyze PATH=workspace/incoming  # Full analysis

# Tracking progress
make trends DAYS=7         # Weekly productivity trends
make analytics            # Daily insights
```

## 📈 Analytics Examples

### Productivity Patterns
- **High productivity days**: Many file changes, diverse focus areas
- **Planning days**: Documentation heavy, few code changes
- **Research days**: Long sessions, decision-making activities

### Team Metrics
- **Collaboration intensity**: Research thread frequency
- **Decision velocity**: ADR approval rate
- **Focus alignment**: Consistent focus areas across team

## 🎯 Best Practices from Examples

1. **Document Structure**
   - Use clear headings (## for epics)
   - Include bullet points for tasks
   - Mark priorities with ! and ‼

2. **Research Workflow**
   - Ask specific, actionable questions
   - Document alternatives thoroughly
   - Include implementation steps in actions.md

3. **Team Coordination**
   - Use ADRs for significant technical decisions
   - Research threads for complex problems
   - Regular analytics review for team health

4. **Progress Tracking**
   - Daily `make done` for consistent snapshots
   - Weekly `make trends` for pattern recognition
   - Monthly deep-dive analytics review

Ready to explore? Start with the [Personal Project](personal-project/) example! 🚀