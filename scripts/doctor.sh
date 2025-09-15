#!/usr/bin/env bash
set -euo pipefail

# HelmStack Environment Diagnostics
# Comprehensive health check for optimal HelmStack usage
# Now with auto-remediation capabilities via --fix flag

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Status icons
CHECK="✅"
WARN="⚠️ "
ERROR="❌"
INFO="ℹ️ "
FIX="🔧"

# Global variables
AUTO_FIX=false
DRY_RUN=false
FIXES_APPLIED=0

# Results tracking
PASS_COUNT=0
WARN_COUNT=0
ERROR_COUNT=0

log_check() {
    local status="$1"
    local message="$2"
    local detail="${3:-}"

    case "$status" in
        "pass")
            echo -e "  ${CHECK} ${GREEN}${message}${NC}"
            [ -n "$detail" ] && echo -e "    ${INFO} $detail"
            CHECKS_PASSED=$((CHECKS_PASSED + 1))
            ;;
        "warn")
            echo -e "  ${WARN} ${YELLOW}${message}${NC}"
            [ -n "$detail" ] && echo -e "    ${INFO} $detail"
            WARNINGS_FOUND=$((WARNINGS_FOUND + 1))
            ;;
        "error")
            echo -e "  ${ERROR} ${RED}${message}${NC}"
            [ -n "$detail" ] && echo -e "    ${INFO} $detail"
            ISSUES_FOUND=$((ISSUES_FOUND + 1))
            ;;
        "info")
            echo -e "  ${INFO} ${CYAN}${message}${NC}"
            [ -n "$detail" ] && echo -e "    $detail"
            ;;
    esac
}

section_header() {
    echo ""
    echo -e "${BOLD}${PURPLE}$1${NC}"
    echo -e "${PURPLE}$(echo "$1" | sed 's/./─/g')${NC}"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Auto-fix functions
apply_fix() {
    local fix_name="$1"
    local fix_command="$2"
    local description="$3"

    if [ "$AUTO_FIX" = true ]; then
        echo -e "  ${FIX} ${YELLOW}Applying fix: $description${NC}"

        if [ "$DRY_RUN" = true ]; then
            echo -e "    ${INFO} Would run: $fix_command"
            ((FIXES_APPLIED++))
        else
            if eval "$fix_command" 2>/dev/null; then
                echo -e "    ${CHECK} ${GREEN}Fix applied successfully${NC}"
                ((FIXES_APPLIED++))
            else
                echo -e "    ${ERROR} ${RED}Fix failed${NC}"
            fi
        fi
    else
        echo -e "    ${INFO} To fix: $fix_command"
    fi
}

show_help() {
    cat << EOF
Usage: $0 [OPTIONS]

HelmStack Environment Diagnostics and Auto-Remediation

OPTIONS:
    --fix           Enable automatic fixes for detected issues
    --dry-run       Show what fixes would be applied without executing them
    --help, -h      Show this help message

EXAMPLES:
    $0              # Run diagnostic checks only
    $0 --fix        # Run checks and apply fixes automatically
    $0 --dry-run    # Show what fixes would be applied
    $0 --fix --dry-run  # Show fixes without applying them

SECTIONS:
    🔧 Git Environment
    🔗 GitHub CLI Integration
    🐍 Python Environment
    ✅ Pre-commit Hooks
    🚀 HelmStack Environment
    🔐 Environment Variables

Auto-fixable issues include:
    • Missing workspace directories
    • Incorrect script permissions
    • Missing pre-commit hooks
    • Git repository initialization
    • Basic Python package installation
EOF
}

# Check if git is installed and working
check_git() {
    section_header "🔧 Git Environment"

    if command_exists git; then
        local git_version=$(git --version 2>/dev/null | cut -d' ' -f3)
        log_check "pass" "Git is installed" "Version: $git_version"

        # Check if in git repository
        if git rev-parse --git-dir >/dev/null 2>&1; then
            log_check "pass" "Currently in a git repository"

            # Check git config
            local git_user=$(git config user.name 2>/dev/null || echo "")
            local git_email=$(git config user.email 2>/dev/null || echo "")

            if [ -n "$git_user" ] && [ -n "$git_email" ]; then
                log_check "pass" "Git user configured" "User: $git_user <$git_email>"
            else
                log_check "warn" "Git user not fully configured" "Run: git config --global user.name 'Your Name' && git config --global user.email 'you@example.com'"
            fi

            # Check for remote
            if git remote get-url origin >/dev/null 2>&1; then
                local remote_url=$(git remote get-url origin)
                log_check "pass" "Remote repository configured" "Origin: $remote_url"
            else
                log_check "warn" "No remote repository configured" "Consider: hs repo or git remote add origin <url>"
            fi
        else
            log_check "warn" "Not in a git repository" "Run: git init or hs start"
            apply_fix "git_init" "git init" "Initialize git repository"
        fi
    else
        log_check "error" "Git not installed" "Install from: https://git-scm.com/downloads"
    fi
}

# Check GitHub CLI
check_github_cli() {
    section_header "🐙 GitHub CLI"

    if command_exists gh; then
        local gh_version=$(gh --version 2>/dev/null | head -1 | cut -d' ' -f3)
        log_check "pass" "GitHub CLI installed" "Version: $gh_version"

        # Check authentication
        if gh auth status >/dev/null 2>&1; then
            local gh_user=$(gh auth status 2>&1 | grep 'Logged in' | cut -d' ' -f6 || echo "unknown")
            log_check "pass" "GitHub CLI authenticated" "User: $gh_user"

            # Check for admin:org scope if applicable
            local scopes=$(gh auth status 2>&1 | grep -o 'scopes:.*' || echo "")
            if echo "$scopes" | grep -q "admin:org\|repo"; then
                log_check "pass" "GitHub CLI has required scopes"
            else
                log_check "warn" "Limited GitHub CLI scopes" "For full functionality: gh auth refresh -s admin:org"
            fi
        else
            log_check "error" "GitHub CLI not authenticated" "Run: gh auth login"
        fi
    else
        log_check "error" "GitHub CLI not installed" "Install from: https://cli.github.com/"
    fi
}

# Check Python environment
check_python() {
    section_header "🐍 Python Environment"

    if command_exists python3; then
        local python_version=$(python3 --version | cut -d' ' -f2)
        log_check "pass" "Python 3 installed" "Version: $python_version"

        # Check minimum version (3.8+)
        local major=$(echo "$python_version" | cut -d'.' -f1)
        local minor=$(echo "$python_version" | cut -d'.' -f2)

        if [ "$major" -gt 3 ] || ([ "$major" -eq 3 ] && [ "$minor" -ge 8 ]); then
            log_check "pass" "Python version is compatible" "Minimum: 3.8, Found: $python_version"
        else
            log_check "warn" "Python version may be too old" "Recommended: 3.8+, Found: $python_version"
        fi

        # Check pip
        if command_exists pip3; then
            log_check "pass" "pip3 available"
        else
            log_check "warn" "pip3 not found" "Some features may require additional packages"
        fi

        # Check for optional packages
        local packages_to_check="python-docx PyPDF2 ruff black markdownlint-cli2 yamllint"
        local missing_packages=""

        for package in $packages_to_check; do
            if python3 -c "import ${package//-/_}" 2>/dev/null; then
                continue
            else
                missing_packages="$missing_packages $package"
            fi
        done

        if [ -n "$missing_packages" ]; then
            log_check "info" "Optional packages missing" "Install with: pip3 install$missing_packages"
        else
            log_check "pass" "All optional Python packages available"
        fi
    else
        log_check "error" "Python 3 not installed" "Install from: https://python.org/downloads/"
    fi
}

# Check pre-commit
check_precommit() {
    section_header "🔒 Pre-commit Hooks"

    if command_exists pre-commit; then
        local precommit_version=$(pre-commit --version | cut -d' ' -f2)
        log_check "pass" "pre-commit installed" "Version: $precommit_version"

        # Check if hooks are installed
        if [ -f ".git/hooks/pre-commit" ] && grep -q "pre-commit" ".git/hooks/pre-commit" 2>/dev/null; then
            log_check "pass" "Pre-commit hooks installed"

            # Check hook configuration
            if [ -f ".pre-commit-config.yaml" ]; then
                local hook_count=$(grep -c "repo:" ".pre-commit-config.yaml" || echo "0")
                log_check "pass" "Pre-commit configuration found" "$hook_count repositories configured"
            else
                log_check "warn" "No pre-commit configuration" "Missing .pre-commit-config.yaml"
            fi
        else
            log_check "warn" "Pre-commit hooks not installed" "Run: pre-commit install"
            apply_fix "precommit_install" "pre-commit install" "Install pre-commit hooks"
        fi
    else
        log_check "warn" "pre-commit not installed" "Install with: pip3 install pre-commit"
        apply_fix "precommit_package" "pip3 install pre-commit" "Install pre-commit package"
    fi
}

# Check HelmStack specific requirements
check_helmstack() {
    section_header "🚀 HelmStack Environment"

    # Check for Helmfile
    if [ -f "Helmfile" ]; then
        log_check "pass" "Helmfile found" "hs runner interface available"
    else
        log_check "error" "Helmfile not found" "Not in a HelmStack project directory"
        return
    fi

    # Check scripts directory
    if [ -d "scripts" ] && [ -x "scripts/help.sh" ]; then
        log_check "pass" "Scripts directory configured"

        # Count executable scripts
        local script_count=$(find scripts -name "*.sh" -executable | wc -l)
        local python_script_count=$(find scripts -name "*.py" -executable | wc -l)
        log_check "info" "Scripts available" "$script_count shell scripts, $python_script_count Python scripts"
    else
        log_check "warn" "Scripts directory missing or not executable" "Run: chmod +x scripts/*.sh scripts/*.py"
        apply_fix "script_permissions" "chmod +x scripts/*.sh scripts/*.py 2>/dev/null || true" "Fix script permissions"
    fi

    # Check workspace structure
    local workspace_dirs="workspace/incoming workspace/plans workspace/research memory snapshots"
    local missing_dirs=""

    for dir in $workspace_dirs; do
        if [ ! -d "$dir" ]; then
            missing_dirs="$missing_dirs $dir"
        fi
    done

    if [ -z "$missing_dirs" ]; then
        log_check "pass" "Workspace structure complete"
    else
        log_check "warn" "Missing workspace directories" "Run: hs start to initialize: $missing_dirs"
        apply_fix "workspace_dirs" "mkdir -p $missing_dirs" "Create missing workspace directories"
    fi

    # Check for key files
    if [ -f "README.md" ] && grep -q "HelmStack" "README.md"; then
        log_check "pass" "HelmStack README present"
    else
        log_check "warn" "README.md missing or not HelmStack project"
    fi
}

# Check secrets and environment variables
check_environment() {
    section_header "🔐 Environment & Secrets"

    # Check for GitHub token
    if [ -n "${GITHUB_TOKEN:-}" ]; then
        log_check "pass" "GITHUB_TOKEN environment variable set"
    else
        log_check "info" "GITHUB_TOKEN not set" "Optional for enhanced GitHub integration"
    fi

    # Check for PROJECT_V2_ID
    if [ -n "${PROJECT_V2_ID:-}" ]; then
        log_check "pass" "PROJECT_V2_ID configured" "GitHub Project v2 automation enabled"
    else
        log_check "warn" "PROJECT_V2_ID not configured" "GitHub Project v2 automation disabled"
        log_check "info" "To enable" "Set PROJECT_V2_ID in repository secrets or environment"
    fi

    # Check shell
    log_check "info" "Shell environment" "Shell: ${SHELL:-unknown}, User: ${USER:-unknown}"

    # Check PATH for common tools
    local path_tools="make git python3"
    for tool in $path_tools; do
        if command_exists "$tool"; then
            local tool_path=$(command -v "$tool")
            log_check "info" "$tool location" "$tool_path"
        fi
    done
}

# Generate summary and recommendations
generate_summary() {
    section_header "📊 Health Check Summary"

    local total_checks=$((PASS_COUNT + WARN_COUNT + ERROR_COUNT))

    echo -e "  ${BOLD}Total Checks: $total_checks${NC}"
    echo -e "  ${GREEN}✅ Passed: $PASS_COUNT${NC}"
    echo -e "  ${YELLOW}⚠️  Warnings: $WARN_COUNT${NC}"
    echo -e "  ${RED}❌ Issues: $ERROR_COUNT${NC}"

    if [ "$AUTO_FIX" = true ]; then
        echo -e "  ${FIX} ${CYAN}Fixes Applied: $FIXES_APPLIED${NC}"
    fi
    echo ""

    # Overall health assessment
    if [ $ERROR_COUNT -eq 0 ] && [ $WARN_COUNT -eq 0 ]; then
        echo -e "  ${GREEN}${BOLD}🎉 Perfect Health!${NC} Your HelmStack environment is fully optimized."
    elif [ $ERROR_COUNT -eq 0 ]; then
        echo -e "  ${YELLOW}${BOLD}👍 Good Health${NC} Minor improvements possible, but fully functional."
    elif [ $ERROR_COUNT -le 2 ]; then
        echo -e "  ${YELLOW}${BOLD}⚡ Needs Attention${NC} A few issues need resolution for optimal experience."
    else
        echo -e "  ${RED}${BOLD}🚨 Needs Setup${NC} Several critical issues require attention."
    fi

    # Quick fix suggestions
    if [ $ERROR_COUNT -gt 0 ] || [ $WARN_COUNT -gt 0 ]; then
        echo ""
        echo -e "${BOLD}${CYAN}💡 Quick Fixes:${NC}"
        echo -e "  • Run ${BOLD}hs doctor --fix${NC} for auto-remediation"
        echo -e "  • Visit ${BOLD}https://github.com/raufA1/HelmStack${NC} for setup guides"
        echo -e "  • Check individual messages above for specific instructions"
    fi

    echo ""
    echo -e "${PURPLE}────────────────────────────────────────────────────────${NC}"
    echo -e "${BOLD}${CYAN}HelmStack Doctor v2.1.0 - Environment Health Check Complete${NC}"
    echo ""

    # Exit code based on issues
    if [ $ERROR_COUNT -gt 0 ]; then
        exit 1
    elif [ $WARN_COUNT -gt 0 ]; then
        exit 2
    else
        exit 0
    fi
}

# Main execution
main() {
    echo ""
    echo -e "${BOLD}${CYAN}🩺 HelmStack Doctor - Environment Diagnostics${NC}"
    echo -e "${PURPLE}═══════════════════════════════════════════════${NC}"

    if [ "$AUTO_FIX" = true ]; then
        if [ "$DRY_RUN" = true ]; then
            echo -e "Checking environment and showing potential fixes (dry run)..."
        else
            echo -e "Checking environment and applying fixes automatically..."
        fi
    else
        echo -e "Checking your environment for optimal HelmStack usage..."
    fi

    # Run all checks
    check_git
    check_github_cli
    check_python
    check_precommit
    check_helmstack
    check_environment

    # Generate summary
    generate_summary
}

# Handle arguments
case "${1:-}" in
    "--version"|"-v")
        echo "HelmStack Doctor v2.1.0"
        exit 0
        ;;
    "--help"|"-h")
        show_help
        exit 0
        ;;
    "--fix")
        AUTO_FIX=true
        main
        ;;
    "--dry-run")
        DRY_RUN=true
        AUTO_FIX=true
        main
        ;;
    "--fix"|"--dry-run")
        # Handle multiple flags
        shift
        while [[ $# -gt 0 ]]; do
            case $1 in
                --fix)
                    AUTO_FIX=true
                    ;;
                --dry-run)
                    DRY_RUN=true
                    AUTO_FIX=true
                    ;;
                *)
                    echo "Unknown option: $1"
                    echo "Use --help for usage information"
                    exit 1
                    ;;
            esac
            shift
        done
        main
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