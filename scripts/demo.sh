#!/usr/bin/env bash
set -euo pipefail

# HelmStack Demo Mode
# Creates a minimal demo project to showcase HelmStack features

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m'

DEMO_DIR="workspace/demo"
CLEANUP_FLAG=false

log_step() {
    echo -e "${BOLD}${BLUE}▶${NC} $1"
}

log_success() {
    echo -e "${GREEN}✅${NC} $1"
}

log_info() {
    echo -e "${CYAN}ℹ️${NC}  $1"
}

show_header() {
    echo ""
    echo -e "${BOLD}${PURPLE}🎬 HelmStack Demo Mode${NC}"
    echo -e "${PURPLE}════════════════════${NC}"
    echo "Showcasing HelmStack capabilities with a sample project..."
    echo ""
}

cleanup_demo() {
    if [ -d "$DEMO_DIR" ]; then
        log_step "Cleaning up previous demo data..."
        rm -rf "$DEMO_DIR"
        log_success "Demo directory cleaned"
    fi
}

create_demo_workspace() {
    log_step "Creating demo workspace structure..."

    mkdir -p "$DEMO_DIR"
    mkdir -p "workspace/incoming"
    mkdir -p "workspace/plans"
    mkdir -p "workspace/research"

    log_success "Demo workspace created"
}

create_sample_documents() {
    log_step "Generating sample project documents..."

    # Create a sample project specification
    cat > "workspace/incoming/demo_project_spec.md" << 'EOF'
# Demo Project: Task Management System

## Overview
A lightweight task management system to demonstrate HelmStack workflow capabilities.

## Epic: User Management
- Implement user registration and authentication
- Design user profile management
- Add user preferences and settings

## Epic: Task Operations
- Create task creation interface
- Build task listing and filtering
- Add task editing and deletion
- Implement task priority and status tracking

## Milestone: M1 - Foundation
- Set up project structure
- Implement basic CRUD operations
- Create user authentication system

## Milestone: M2 - Core Features
- Advanced task filtering
- Task categories and tags
- Due date management
- User notifications

## Technical Requirements
- Use modern web framework (React/Vue)
- Implement RESTful API backend
- Add database for persistence
- Include comprehensive testing

## Risks and Blockers
- Database schema complexity
- User authentication security
- Performance with large datasets
- Mobile responsiveness requirements

## Success Criteria
- [ ] User can register and login
- [ ] User can create and manage tasks
- [ ] System handles 1000+ concurrent users
- [ ] Mobile-friendly interface
- [ ] Comprehensive test coverage >90%
EOF

    # Create additional sample document
    cat > "workspace/incoming/technical_notes.md" << 'EOF'
# Technical Implementation Notes

## Architecture Decisions
- Frontend: React with TypeScript
- Backend: Node.js with Express
- Database: PostgreSQL
- Authentication: JWT tokens

## Development Tasks
- Set up development environment
- Create database migrations
- Implement API endpoints
- Design UI components
- Write unit and integration tests
- Set up CI/CD pipeline

## Research Topics
- Best practices for JWT security
- Database indexing strategies
- React state management patterns
- Testing frameworks comparison
EOF

    log_success "Sample documents created"
    log_info "Files created in workspace/incoming/"
}

run_demo_workflow() {
    log_step "Running HelmStack workflow demonstration..."

    echo ""
    echo -e "${YELLOW}📄 Step 1: Document Analysis (hs fix)${NC}"
    make -f Helmfile fix >/dev/null 2>&1 || true

    if [ -f "workspace/plans/STATUS.md" ]; then
        log_success "Generated STATUS.md with project analysis"
        log_info "Found $(grep -c "^-" workspace/plans/STATUS.md 2>/dev/null || echo 0) analyzed items"
    fi

    if [ -f "workspace/plans/NEXT_STEPS.md" ]; then
        log_success "Generated NEXT_STEPS.md with actionable tasks"
        log_info "Extracted $(grep -c "^- \[ \]" workspace/plans/NEXT_STEPS.md 2>/dev/null || echo 0) tasks"
    fi

    echo ""
    echo -e "${YELLOW}🎯 Step 2: Focus List Creation (hs work)${NC}"
    make -f Helmfile work >/dev/null 2>&1 || true

    if [ -f "workspace/plans/FOCUS_LIST.md" ]; then
        log_success "Generated FOCUS_LIST.md for immediate work"
        log_info "Prioritized top work items for current session"
    fi

    echo ""
    echo -e "${YELLOW}🧠 Step 3: Memory Refresh${NC}"
    make -f Helmfile memory >/dev/null 2>&1 || true

    if [ -f "memory/MEMORY.md" ]; then
        log_success "Updated AI memory with project context"
    fi

    echo ""
    echo -e "${YELLOW}📊 Step 4: Analytics Generation${NC}"
    make -f Helmfile analytics >/dev/null 2>&1 || true
    log_success "Analytics system updated"
}

create_demo_snapshot() {
    log_step "Creating demo session snapshot..."

    make -f Helmfile snapshot >/dev/null 2>&1 || true

    # Find the latest snapshot
    local latest_snapshot=$(ls -t snapshots/snap-*.txt 2>/dev/null | head -1 || echo "")
    if [ -n "$latest_snapshot" ]; then
        log_success "Demo snapshot created: $(basename "$latest_snapshot")"
    fi
}

show_demo_results() {
    echo ""
    echo -e "${BOLD}${PURPLE}📊 Demo Results${NC}"
    echo -e "${PURPLE}═══════════════${NC}"

    # Show generated files
    echo -e "${BOLD}Generated Files:${NC}"

    if [ -f "workspace/plans/STATUS.md" ]; then
        echo -e "${GREEN}✅${NC} STATUS.md - Project status overview"
    fi

    if [ -f "workspace/plans/NEXT_STEPS.md" ]; then
        echo -e "${GREEN}✅${NC} NEXT_STEPS.md - Actionable task list"
    fi

    if [ -f "workspace/plans/FOCUS_LIST.md" ]; then
        echo -e "${GREEN}✅${NC} FOCUS_LIST.md - Current session priorities"
    fi

    if [ -f "memory/MEMORY.md" ]; then
        echo -e "${GREEN}✅${NC} MEMORY.md - AI project memory"
    fi

    # Show sample content
    echo ""
    echo -e "${BOLD}Sample Output Preview:${NC}"

    if [ -f "workspace/plans/FOCUS_LIST.md" ]; then
        echo -e "${CYAN}📋 Current Focus List:${NC}"
        head -10 "workspace/plans/FOCUS_LIST.md" | sed 's/^/  /'
    fi

    echo ""
    echo -e "${BOLD}${YELLOW}🎯 What You Can Do Next:${NC}"
    echo -e "  • Explore generated files in workspace/plans/"
    echo -e "  • Run ${BOLD}hs status${NC} to see project overview"
    echo -e "  • Run ${BOLD}hs next${NC} to view next steps"
    echo -e "  • Run ${BOLD}hs memory${NC} to see AI project memory"
    echo -e "  • Add your own documents to workspace/incoming/ and run ${BOLD}hs fix${NC}"

    # Demo cleanup option
    echo ""
    echo -e "${BOLD}Demo Cleanup:${NC}"
    echo -e "  • Run ${BOLD}hs demo --cleanup${NC} to remove demo data"
    echo -e "  • Or manually remove $DEMO_DIR directory"
}

show_help() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  --cleanup      Remove existing demo data"
    echo "  --help, -h     Show this help message"
    echo ""
    echo "HelmStack Demo Mode showcases:"
    echo "  • Document analysis and processing"
    echo "  • Task extraction and prioritization"
    echo "  • AI memory and context management"
    echo "  • Session analytics and tracking"
    echo ""
    echo "The demo creates sample documents and runs through the"
    echo "complete HelmStack workflow to demonstrate capabilities."
}

main() {
    show_header

    # Clean up if requested
    if [ "$CLEANUP_FLAG" = true ]; then
        cleanup_demo
        echo ""
        echo -e "${GREEN}✅ Demo cleanup complete!${NC}"
        exit 0
    fi

    # Run demo workflow
    cleanup_demo
    create_demo_workspace
    create_sample_documents

    echo ""
    log_step "Running complete HelmStack workflow..."
    echo -e "${CYAN}This demonstrates the full document → analysis → action workflow${NC}"
    echo ""

    run_demo_workflow
    create_demo_snapshot
    show_demo_results

    echo ""
    echo -e "${PURPLE}════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${GREEN}🎉 HelmStack Demo Complete!${NC}"
    echo -e "${CYAN}You've seen how HelmStack transforms documents into actionable workflows.${NC}"
    echo ""
}

# Handle command line arguments
case "${1:-}" in
    "--cleanup")
        CLEANUP_FLAG=true
        main
        ;;
    "--help"|"-h")
        show_help
        ;;
    "")
        main
        ;;
    *)
        echo "Unknown option: $1"
        echo "Use --help for usage information"
        exit 1
        ;;
esac