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
echo -e "${BOLD}${CYAN}🚀 HelmStack Community Edition - Document-First Project Management${NC}"
echo -e "${PURPLE}──────────────────────────────────────────────────────────────────${NC}"
echo ""

echo -e "${BOLD}${GREEN}🎯 Core Workflow${NC}"
echo -e "  ${YELLOW}start${NC}     - 🔥 Initialize project with directory structure"
echo -e "  ${YELLOW}fix${NC}       - 🧭 Refresh plan (basic document analysis)"
echo -e "  ${YELLOW}work${NC}      - 🎯 Build FOCUS_LIST from NEXT_STEPS"
echo -e "  ${YELLOW}done${NC}      - ✅ End of day - basic session wrap-up"
echo ""

echo -e "${BOLD}${BLUE}🏗️ GitHub Integration${NC}"
echo -e "  ${YELLOW}init${NC}      - 🆕 Initialize new HelmStack project (NAME=\"...\" DESC=\"...\")"
echo -e "  ${YELLOW}repo${NC}      - 🏗️ Create GitHub repository (NAME=\"...\" PRIVATE=true/false)"
echo -e "  ${YELLOW}publish${NC}   - 🚀 Initial push to GitHub (creates main branch)"
echo -e "  ${YELLOW}setup${NC}     - ⚙️ Bootstrap GitHub features (labels/milestones)"
echo ""

echo -e "${BOLD}${GREEN}🏗️ Architecture Decisions${NC}"
echo -e "  ${YELLOW}adr-new${NC}   - 📝 Create new ADR (TITLE=\"...\")"
echo -e "  ${YELLOW}adr-list${NC}  - 📋 List all ADRs"
echo ""

echo -e "${BOLD}${WHITE}📝 Templates & Tools${NC}"
echo -e "  ${YELLOW}template${NC}  - 📄 Create template (TYPE=todo|spec|adr FILE=...)"
echo ""

echo -e "${BOLD}${BLUE}🔧 Status & Management${NC}"
echo -e "  ${YELLOW}status${NC}    - 📊 Show current project status"
echo -e "  ${YELLOW}next${NC}      - 📌 Show next steps"
echo -e "  ${YELLOW}focus${NC}     - 🎯 Show current focus list"
echo -e "  ${YELLOW}doctor${NC}    - 🩺 Environment diagnostics and health check"
echo -e "  ${YELLOW}demo${NC}      - 🎬 Run interactive demo with sample project"
echo -e "  ${YELLOW}help${NC}      - 📖 Show this help message"
echo ""

echo -e "${BOLD}${CYAN}📁 Workspace Structure${NC}"
echo -e "  ${GREEN}workspace/incoming/${NC}  - Input documents"
echo -e "  ${GREEN}workspace/plans/${NC}     - Generated plans & status"
echo -e "  ${GREEN}workspace/research/${NC}  - Research findings"
echo ""

echo -e "${BOLD}${PURPLE}🚀 Command Aliases${NC}"
echo -e "  ${YELLOW}go${NC}        = ${CYAN}start${NC}    # Quick project initialization"
echo -e "  ${YELLOW}plan${NC}      = ${CYAN}fix${NC}      # Refresh planning documents"
echo ""

echo -e "${BOLD}${PURPLE}💡 Quick Start${NC}"
echo -e "  ${BOLD}New Project:${NC}"
echo -e "  1. ${CYAN}hs init NAME=\"MyProject\" DESC=\"Description\"${NC}"
echo -e "  2. ${CYAN}cd MyProject${NC}"
echo -e "  3. ${CYAN}hs repo NAME=\"MyProject\" DESC=\"Description\"${NC}"
echo -e "  4. ${CYAN}hs publish${NC}"
echo ""
echo -e "  ${BOLD}Daily Workflow:${NC}"
echo -e "  1. ${CYAN}hs fix${NC}      # Generate/refresh plan"
echo -e "  2. ${CYAN}hs work${NC}     # Create focus list"
echo -e "  3. ${CYAN}hs done${NC}     # End session"
echo ""

echo -e "${BOLD}${YELLOW}✨ HelmStack Pro Features${NC}"
echo -e "  ${PURPLE}🤖 AI-Powered Analysis${NC}     - Smart document processing"
echo -e "  ${PURPLE}📊 Advanced Analytics${NC}      - Productivity insights & trends"
echo -e "  ${PURPLE}🔎 Research Automation${NC}     - Human-in-the-loop workflows"
echo -e "  ${PURPLE}🧠 Smart Memory${NC}            - Context-aware project management"
echo -e "  ${PURPLE}📥 Document Conversion${NC}     - PDF/DOCX to Markdown"
echo -e "  ${PURPLE}📈 Session Comparison${NC}      - Snapshot diff analysis"
echo ""
echo -e "  ${CYAN}Learn more: ${BOLD}hs upgrade${NC} ${CYAN}or visit https://helmstack.dev/pro${NC}"
echo ""

echo -e "${PURPLE}──────────────────────────────────────────────────────────────────${NC}"
echo -e "${BOLD}${CYAN}HelmStack Community Edition - Open source document-first workflow${NC}"
echo ""