#!/usr/bin/env bash

# ANSI Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo ""
echo -e "${BOLD}${CYAN}🚀 HelmStack - Document-First Project Management${NC}"
echo -e "${PURPLE}───────────────────────────────────────────────────${NC}"
echo ""

echo -e "${BOLD}${GREEN}🎯 Core Workflow${NC}"
echo -e "  ${YELLOW}start${NC}     - 🔥 Initialize project with directory structure"
echo -e "  ${YELLOW}fix${NC}       - 🧭 Refresh plan (STATUS.md + NEXT_STEPS.md)"
echo -e "  ${YELLOW}work${NC}      - 🎯 Build FOCUS_LIST from NEXT_STEPS"
echo -e "  ${YELLOW}done${NC}      - ✅ End of day - snapshot + git commit/tag/push"
echo ""

echo -e "${BOLD}${BLUE}📋 Document Analysis${NC}"
echo -e "  ${YELLOW}analyze${NC}   - 📄 Analyze docs with pluggable analyzers"
echo -e "  ${YELLOW}epics${NC}     - 📚 Extract epics from documents"
echo -e "  ${YELLOW}milestones${NC} - 🎯 Extract milestones"
echo -e "  ${YELLOW}ideas${NC}     - 💡 Extract ideas and suggestions"
echo -e "  ${YELLOW}risks${NC}     - ⚠️ Extract risks and blockers"
echo ""

echo -e "${BOLD}${PURPLE}🧠 AI Memory System${NC}"
echo -e "  ${YELLOW}memory${NC}    - 🧠 Show comprehensive AI memory summary"
echo -e "  ${YELLOW}context${NC}   - 🎯 Show quick context for current session"
echo -e "  ${YELLOW}refresh${NC}   - 🔄 Refresh AI memory from all workspace files"
echo ""

echo -e "${BOLD}${CYAN}🔍 Research Workflow (HITL)${NC}"
echo -e "  ${YELLOW}ask${NC}       - 🔎 Start research thread (TOPIC=\"...\")"
echo -e "  ${YELLOW}check${NC}     - 🧪 Summarize findings for review"
echo -e "  ${YELLOW}yes${NC}       - ✅ Approve research proposal"
echo -e "  ${YELLOW}no${NC}        - ✏️ Request changes to research"
echo -e "  ${YELLOW}end${NC}       - 🏁 Complete research thread"
echo ""

echo -e "${BOLD}${GREEN}📊 Analytics & Metrics${NC}"
echo -e "  ${YELLOW}analytics${NC} - 📈 Session productivity analytics"
echo -e "  ${YELLOW}trends${NC}    - 📊 Show productivity trends (DAYS=7)"
echo -e "  ${YELLOW}snapshot${NC}  - 📸 Create session snapshot"
echo ""

echo -e "${BOLD}${YELLOW}🏗️ Architecture Decisions${NC}"
echo -e "  ${YELLOW}adr-new${NC}   - 📝 Create new ADR (TITLE=\"...\")"
echo -e "  ${YELLOW}adr-list${NC}  - 📋 List all ADRs"
echo -e "  ${YELLOW}adr-accept${NC} - ✅ Accept ADR (ID=001)"
echo -e "  ${YELLOW}adr-reject${NC} - ❌ Reject ADR (ID=001)"
echo ""

echo -e "${BOLD}${BLUE}📝 Templates & Tools${NC}"
echo -e "  ${YELLOW}template${NC}  - 📄 Create template (TYPE=todo|spec|adr FILE=...)"
echo -e "  ${YELLOW}extract${NC}   - 📄 Extract text from PDF/DOCX files"
echo -e "  ${YELLOW}setup${NC}     - ⚙️ GitHub repository bootstrap"
echo ""

echo -e "${BOLD}${WHITE}🔧 Status & Management${NC}"
echo -e "  ${YELLOW}status${NC}    - 📊 Show current project status"
echo -e "  ${YELLOW}next${NC}      - 📌 Show next steps"
echo -e "  ${YELLOW}focus${NC}     - 🎯 Show current focus list"
echo -e "  ${YELLOW}clean${NC}     - 🧹 Clean generated files"
echo -e "  ${YELLOW}help${NC}      - 📖 Show this help message"
echo ""

echo -e "${BOLD}${CYAN}📁 Workspace Structure${NC}"
echo -e "  ${GREEN}workspace/incoming/${NC}  - Input documents"
echo -e "  ${GREEN}workspace/plans/${NC}     - Generated plans & status"
echo -e "  ${GREEN}workspace/research/${NC}  - Research findings"
echo -e "  ${GREEN}memory/${NC}              - AI memory & context"
echo -e "  ${GREEN}snapshots/${NC}           - Session snapshots"
echo ""

echo -e "${BOLD}${PURPLE}🚀 Command Aliases${NC}"
echo -e "  ${YELLOW}go${NC}        = ${CYAN}start${NC}    # Quick project initialization"
echo -e "  ${YELLOW}plan${NC}      = ${CYAN}fix${NC}      # Refresh planning documents"
echo -e "  ${YELLOW}save${NC}      = ${CYAN}snapshot${NC} # Create session snapshot"
echo ""

echo -e "${BOLD}${PURPLE}💡 Quick Start${NC}"
echo -e "  1. ${CYAN}make start NAME=\"MyProject\" DESC=\"Description\"${NC}"
echo -e "  2. ${CYAN}make fix${NC}     # Generate initial plan"
echo -e "  3. ${CYAN}make work${NC}    # Create focus list"
echo -e "  4. ${CYAN}make done${NC}    # End session"
echo ""

echo -e "${PURPLE}───────────────────────────────────────────────────${NC}"
echo -e "${BOLD}${CYAN}Document-first, AI-powered project flow.${NC}"
echo ""
