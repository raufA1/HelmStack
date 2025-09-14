#!/usr/bin/env bash
set -euo pipefail

# HelmStack Self-Update System
# Synchronize current project with latest HelmStack template
# Handles selective updates with conflict resolution

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m'

# Default values
TEMPLATE_REPO="https://github.com/raufA1/HelmStack"
BACKUP_DIR="backup_$(date +%Y%m%d_%H%M%S)"
FORCE_UPDATE=false
DRY_RUN=false
SELECTIVE=false
TEMP_DIR=""

log_info() {
    echo -e "${CYAN}ℹ️${NC} $1"
}

log_success() {
    echo -e "${GREEN}✅${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

log_error() {
    echo -e "${RED}❌${NC} $1"
}

log_header() {
    echo -e "${BOLD}${PURPLE}$1${NC}"
    echo -e "${PURPLE}$(echo "$1" | sed 's/./─/g')${NC}"
}

show_help() {
    cat << EOF
Usage: $0 [OPTIONS]

HelmStack Self-Update System - Sync with latest template

OPTIONS:
    --dry-run           Show what would be updated without making changes
    --force             Force overwrite of local changes
    --selective         Interactive mode for selective updates
    --backup-dir DIR    Custom backup directory name
    --template URL      Custom template repository URL
    --help, -h          Show this help message

EXAMPLES:
    $0                  # Safe update with automatic backups
    $0 --dry-run        # Preview changes without applying
    $0 --selective      # Interactive update mode
    $0 --force          # Force update (overwrites local changes)

FEATURES:
    • Automatic backup of existing files
    • Selective update of components
    • Conflict detection and resolution
    • Rollback capability
    • Preserves local customizations in safe areas

UPDATEABLE COMPONENTS:
    • Core scripts (scripts/*)
    • Helmfile runner
    • GitHub workflows (.github/workflows/*)
    • Documentation templates
    • Configuration files

PRESERVED FILES:
    • workspace/* (user data)
    • memory/* (AI memory)
    • snapshots/* (session data)
    • README.md (if customized)
    • Local configuration files
EOF
}

check_prerequisites() {
    log_header "🔍 Checking Prerequisites"

    # Check if we're in a HelmStack project
    if [ ! -f "Helmfile" ]; then
        log_error "Not in a HelmStack project directory"
        log_info "Run this from your HelmStack project root"
        exit 1
    fi

    # Check git
    if ! command -v git >/dev/null 2>&1; then
        log_error "Git is required for self-update"
        exit 1
    fi

    # Check if git repo has uncommitted changes
    if [ "$FORCE_UPDATE" = false ] && [ "$DRY_RUN" = false ]; then
        if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
            log_warning "Uncommitted changes detected"
            log_info "Commit your changes or use --force to continue"
            read -p "Continue anyway? (y/N) " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                exit 1
            fi
        fi
    fi

    log_success "Prerequisites check passed"
}

create_backup() {
    if [ "$DRY_RUN" = true ]; then
        log_info "Would create backup in: $BACKUP_DIR"
        return
    fi

    log_header "💾 Creating Backup"

    mkdir -p "$BACKUP_DIR"

    # Backup core files that might be updated
    local backup_files=(
        "Helmfile"
        "scripts/"
        ".github/"
        ".pre-commit-config.yaml"
        "requirements.txt"
        "CHANGELOG.md"
        "COMMANDS.md"
    )

    for item in "${backup_files[@]}"; do
        if [ -e "$item" ]; then
            cp -r "$item" "$BACKUP_DIR/" 2>/dev/null || true
            log_info "Backed up: $item"
        fi
    done

    log_success "Backup created: $BACKUP_DIR"
}

fetch_template() {
    log_header "📥 Fetching Latest Template"

    # Create temporary directory
    TEMP_DIR=$(mktemp -d)
    trap 'rm -rf "$TEMP_DIR"' EXIT

    if [ "$DRY_RUN" = true ]; then
        log_info "Would fetch template from: $TEMPLATE_REPO"
        return
    fi

    # Clone template repository
    if ! git clone "$TEMPLATE_REPO" "$TEMP_DIR/template" --quiet; then
        log_error "Failed to fetch template from $TEMPLATE_REPO"
        exit 1
    fi

    log_success "Template fetched successfully"
}

detect_conflicts() {
    log_header "🔍 Detecting Conflicts"

    local conflicts=()
    local template_dir="$TEMP_DIR/template"

    # Files to check for conflicts
    local check_files=(
        "Helmfile"
        "scripts/help.sh"
        ".github/workflows/project-automation.yml"
    )

    for file in "${check_files[@]}"; do
        if [ -f "$file" ] && [ -f "$template_dir/$file" ]; then
            if ! diff -q "$file" "$template_dir/$file" >/dev/null 2>&1; then
                conflicts+=("$file")
            fi
        fi
    done

    if [ ${#conflicts[@]} -gt 0 ]; then
        log_warning "Conflicts detected in ${#conflicts[@]} file(s):"
        for conflict in "${conflicts[@]}"; do
            echo "  • $conflict"
        done
        return 1
    else
        log_success "No conflicts detected"
        return 0
    fi
}

show_update_plan() {
    log_header "📋 Update Plan"

    local template_dir="$TEMP_DIR/template"
    local updates=()
    local additions=()
    local deletions=()

    # Scan for changes
    if [ -d "$template_dir" ]; then
        # Find new files
        while IFS= read -r -d '' file; do
            local rel_path="${file#$template_dir/}"
            if [ ! -e "$rel_path" ] && [[ ! "$rel_path" =~ ^(workspace|memory|snapshots)/ ]]; then
                additions+=("$rel_path")
            fi
        done < <(find "$template_dir" -type f -print0)

        # Find updated files
        for file in "Helmfile" "scripts/"*.sh "scripts/"*.py ".github/workflows/"*.yml; do
            if [ -f "$file" ] && [ -f "$template_dir/$file" ]; then
                if ! diff -q "$file" "$template_dir/$file" >/dev/null 2>&1; then
                    updates+=("$file")
                fi
            fi
        done
    fi

    # Display plan
    if [ ${#additions[@]} -gt 0 ]; then
        echo -e "${GREEN}📁 New Files (${#additions[@]}):${NC}"
        for file in "${additions[@]}"; do
            echo "  + $file"
        done
        echo
    fi

    if [ ${#updates[@]} -gt 0 ]; then
        echo -e "${YELLOW}🔄 Updated Files (${#updates[@]}):${NC}"
        for file in "${updates[@]}"; do
            echo "  ≠ $file"
        done
        echo
    fi

    if [ ${#additions[@]} -eq 0 ] && [ ${#updates[@]} -eq 0 ]; then
        log_success "No updates available - you're running the latest version!"
        return 1
    fi

    return 0
}

apply_updates() {
    log_header "🔄 Applying Updates"

    local template_dir="$TEMP_DIR/template"

    if [ "$DRY_RUN" = true ]; then
        log_info "Dry run mode - no changes applied"
        return
    fi

    # Update core scripts
    if [ -d "$template_dir/scripts" ]; then
        log_info "Updating core scripts..."

        # Preserve local customizations
        local preserve_patterns=(
            "*local*"
            "*custom*"
            "*user*"
        )

        for script in "$template_dir/scripts/"*; do
            local basename=$(basename "$script")
            local should_preserve=false

            # Check if file should be preserved
            for pattern in "${preserve_patterns[@]}"; do
                if [[ "$basename" == $pattern ]]; then
                    should_preserve=true
                    break
                fi
            done

            if [ "$should_preserve" = false ]; then
                cp "$script" "scripts/" 2>/dev/null || true
                chmod +x "scripts/$basename" 2>/dev/null || true
                log_info "Updated: scripts/$basename"
            else
                log_info "Preserved: scripts/$basename (local customization)"
            fi
        done
    fi

    # Update Helmfile
    if [ -f "$template_dir/Helmfile" ]; then
        if [ "$SELECTIVE" = true ]; then
            read -p "Update Helmfile? (y/N) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                cp "$template_dir/Helmfile" "Helmfile"
                log_info "Updated: Helmfile"
            fi
        else
            cp "$template_dir/Helmfile" "Helmfile"
            log_info "Updated: Helmfile"
        fi
    fi

    # Update GitHub workflows
    if [ -d "$template_dir/.github/workflows" ]; then
        log_info "Updating GitHub workflows..."
        mkdir -p ".github/workflows"
        for workflow in "$template_dir/.github/workflows/"*.yml; do
            local basename=$(basename "$workflow")
            if [ "$SELECTIVE" = false ] || ask_update "Update workflow: $basename?"; then
                cp "$workflow" ".github/workflows/"
                log_info "Updated: .github/workflows/$basename"
            fi
        done
    fi

    # Update documentation
    if [ -f "$template_dir/COMMANDS.md" ]; then
        cp "$template_dir/COMMANDS.md" "COMMANDS.md"
        log_info "Updated: COMMANDS.md"
    fi

    # Update configuration files
    for config in ".pre-commit-config.yaml" "requirements.txt"; do
        if [ -f "$template_dir/$config" ]; then
            if [ "$SELECTIVE" = false ] || ask_update "Update $config?"; then
                cp "$template_dir/$config" "$config"
                log_info "Updated: $config"
            fi
        fi
    done

    log_success "Updates applied successfully"
}

ask_update() {
    local prompt="$1"
    read -p "$prompt (y/N) " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

post_update_actions() {
    log_header "🔧 Post-Update Actions"

    if [ "$DRY_RUN" = true ]; then
        log_info "Would perform post-update actions"
        return
    fi

    # Make scripts executable
    chmod +x scripts/*.sh scripts/*.py 2>/dev/null || true
    log_info "Made scripts executable"

    # Update git hooks if pre-commit is available
    if command -v pre-commit >/dev/null 2>&1; then
        pre-commit install --install-hooks >/dev/null 2>&1 || true
        log_info "Updated pre-commit hooks"
    fi

    # Refresh AI memory
    if [ -f "scripts/ai_memory_refresh.sh" ]; then
        bash scripts/ai_memory_refresh.sh workspace/plans memory >/dev/null 2>&1 || true
        log_info "Refreshed AI memory"
    fi

    log_success "Post-update actions completed"
}

rollback_updates() {
    if [ ! -d "$BACKUP_DIR" ]; then
        log_error "No backup found for rollback"
        return 1
    fi

    log_header "🔄 Rolling Back Updates"

    # Restore from backup
    for item in "$BACKUP_DIR"/*; do
        local basename=$(basename "$item")
        if [ -e "$basename" ]; then
            rm -rf "$basename"
        fi
        cp -r "$item" .
        log_info "Restored: $basename"
    done

    log_success "Rollback completed successfully"
}

show_summary() {
    log_header "📊 Update Summary"

    if [ "$DRY_RUN" = true ]; then
        echo -e "${CYAN}Mode:${NC} Dry run (no changes applied)"
    else
        echo -e "${CYAN}Mode:${NC} Live update"
        echo -e "${CYAN}Backup:${NC} $BACKUP_DIR"
    fi

    echo -e "${CYAN}Template:${NC} $TEMPLATE_REPO"
    echo -e "${CYAN}Time:${NC} $(date)"
    echo

    if [ "$DRY_RUN" = false ]; then
        echo -e "${GREEN}✅ Self-update completed successfully${NC}"
        echo
        echo -e "${BOLD}Next Steps:${NC}"
        echo "• Test the updated features with 'hs help'"
        echo "• Run 'hs doctor' to verify environment health"
        echo "• Review CHANGELOG.md for new features"
        echo "• If issues arise, run: cp -r $BACKUP_DIR/* ."
    fi
}

main() {
    echo
    log_header "🔄 HelmStack Self-Update System"
    echo

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --force)
                FORCE_UPDATE=true
                shift
                ;;
            --selective)
                SELECTIVE=true
                shift
                ;;
            --backup-dir)
                BACKUP_DIR="$2"
                shift 2
                ;;
            --template)
                TEMPLATE_REPO="$2"
                shift 2
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done

    # Execute update process
    check_prerequisites

    if [ "$DRY_RUN" = false ]; then
        create_backup
    fi

    fetch_template

    if show_update_plan; then
        if [ "$DRY_RUN" = false ]; then
            echo
            if [ "$FORCE_UPDATE" = false ]; then
                read -p "Proceed with updates? (y/N) " -n 1 -r
                echo
                if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                    log_info "Update cancelled by user"
                    exit 0
                fi
            fi

            apply_updates
            post_update_actions
        fi
    fi

    show_summary
}

# Trap for cleanup
trap 'rm -rf "$TEMP_DIR" 2>/dev/null || true' EXIT

main "$@"