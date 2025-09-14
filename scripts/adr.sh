#!/usr/bin/env bash
set -euo pipefail

COMMAND="${1:-}"
ADR_DIR="${2:-memory/decisions}"
TEMPLATE_DIR="${3:-templates/adr}"

usage() {
    echo "Usage: adr.sh [new|list|status|supersede] [title|number]"
    echo ""
    echo "Commands:"
    echo "  new TITLE       - Create new ADR"
    echo "  list           - List all ADRs"
    echo "  status NUMBER  - Show ADR status"
    echo "  supersede OLD NEW - Mark old ADR as superseded"
    echo "  propose TITLE  - Create ADR in proposed status"
    echo "  accept NUMBER  - Accept proposed ADR"
    echo "  reject NUMBER  - Reject proposed ADR"
    echo ""
    echo "Examples:"
    echo "  adr.sh new 'Use PostgreSQL for database'"
    echo "  adr.sh list"
    echo "  adr.sh accept 001"
}

get_next_number() {
    local max_num=0
    if ls "$ADR_DIR"/ADR-*.md >/dev/null 2>&1; then
        for file in "$ADR_DIR"/ADR-*.md; do
            local num=$(basename "$file" | sed 's/ADR-\([0-9]*\).*/\1/')
            if [[ $num =~ ^[0-9]+$ ]] && [ "$num" -gt "$max_num" ]; then
                max_num=$num
            fi
        done
    fi
    printf "%03d" $((max_num + 1))
}

create_adr() {
    local title="$1"
    local status="${2:-Proposed}"
    local number=$(get_next_number)
    local filename="ADR-${number}.md"
    local filepath="$ADR_DIR/$filename"
    local date=$(date '+%Y-%m-%d')
    local review_date=$(date -d '+1 month' '+%Y-%m-%d')

    mkdir -p "$ADR_DIR"

    # Create ADR from template
    sed -e "s/{NUMBER}/$number/g" \
        -e "s/{TITLE}/$title/g" \
        -e "s/{DATE}/$date/g" \
        -e "s/{STATUS}/$status/g" \
        -e "s/{DECISION_MAKERS}/TBD/g" \
        -e "s/{CONTEXT_DESCRIPTION}/Describe the context and problem that needs to be addressed/g" \
        -e "s/{DECISION_DESCRIPTION}/Describe the decision that was made/g" \
        -e "s/{RATIONALE_DESCRIPTION}/Explain why this decision was made/g" \
        -e "s/{POSITIVE_CONSEQUENCE_1}/First positive outcome/g" \
        -e "s/{POSITIVE_CONSEQUENCE_2}/Second positive outcome/g" \
        -e "s/{NEGATIVE_CONSEQUENCE_1}/First negative outcome/g" \
        -e "s/{NEGATIVE_CONSEQUENCE_2}/Second negative outcome/g" \
        -e "s/{RISK_1}/First identified risk/g" \
        -e "s/{RISK_2}/Second identified risk/g" \
        -e "s/{ALT_1_NAME}/First alternative/g" \
        -e "s/{ALT_1_DESC}/Description of first alternative/g" \
        -e "s/{ALT_1_PROS}/Advantages of first alternative/g" \
        -e "s/{ALT_1_CONS}/Disadvantages of first alternative/g" \
        -e "s/{ALT_2_NAME}/Second alternative/g" \
        -e "s/{ALT_2_DESC}/Description of second alternative/g" \
        -e "s/{ALT_2_PROS}/Advantages of second alternative/g" \
        -e "s/{ALT_2_CONS}/Disadvantages of second alternative/g" \
        -e "s/{IMPLEMENTATION_STEP_1}/First implementation step/g" \
        -e "s/{IMPLEMENTATION_STEP_2}/Second implementation step/g" \
        -e "s/{IMPLEMENTATION_STEP_3}/Third implementation step/g" \
        -e "s/{REVIEW_DATE}/$review_date/g" \
        -e "s/{REVIEW_CRITERIA}/Criteria for reviewing this decision/g" \
        -e "s/{RELATED_ADRS}/Links to related ADRs/g" \
        -e "s/{REFERENCES}/External references and documentation/g" \
        -e "s/{RELATED_ISSUES}/Related GitHub issues or tickets/g" \
        "$TEMPLATE_DIR/adr_template.md" > "$filepath"

    echo "✅ Created ADR-$number: $title"
    echo "📝 File: $filepath"
    echo "📝 Edit the file to complete the ADR"

    # Update decisions log
    echo "- $(date '+%Y-%m-%d %H:%M') ADR-$number ($status): $title" >> memory/DECISIONS.md
}

list_adrs() {
    echo "📋 Architecture Decision Records"
    echo ""

    if ! ls "$ADR_DIR"/ADR-*.md >/dev/null 2>&1; then
        echo "No ADRs found. Create one with: adr.sh new 'Your Decision Title'"
        return
    fi

    printf "%-6s %-12s %s\n" "NUM" "STATUS" "TITLE"
    printf "%-6s %-12s %s\n" "---" "------" "-----"

    for file in "$ADR_DIR"/ADR-*.md; do
        if [ -f "$file" ]; then
            local num=$(basename "$file" | sed 's/ADR-\([0-9]*\).*/\1/')
            local title=$(grep "^# ADR-" "$file" | head -n1 | sed 's/^# ADR-[0-9]*: //')
            local status=$(grep "^**Status:**" "$file" | head -n1 | sed 's/^**Status:** //')

            printf "%-6s %-12s %s\n" "$num" "$status" "$title"
        fi
    done
}

show_status() {
    local number="$1"
    local filepath="$ADR_DIR/ADR-$(printf "%03d" "$number").md"

    if [ ! -f "$filepath" ]; then
        echo "❌ ADR-$number not found"
        return 1
    fi

    echo "📄 $(grep "^# ADR-" "$filepath")"
    echo ""
    echo "**Status:** $(grep "^**Status:**" "$filepath" | sed 's/^**Status:** //')"
    echo "**Date:** $(grep "^**Date:**" "$filepath" | sed 's/^**Date:** //')"
    echo ""

    # Show decision summary
    echo "## Decision Summary"
    sed -n '/^## Decision/,/^## /p' "$filepath" | head -n -1 | tail -n +2
}

change_status() {
    local number="$1"
    local new_status="$2"
    local filepath="$ADR_DIR/ADR-$(printf "%03d" "$number").md"

    if [ ! -f "$filepath" ]; then
        echo "❌ ADR-$number not found"
        return 1
    fi

    # Update status in file
    sed -i "s/^**Status:** .*/**Status:** $new_status/" "$filepath"

    # Update decisions log
    local title=$(grep "^# ADR-" "$filepath" | head -n1 | sed 's/^# ADR-[0-9]*: //')
    echo "- $(date '+%Y-%m-%d %H:%M') ADR-$number ($new_status): $title" >> memory/DECISIONS.md

    echo "✅ ADR-$number status changed to: $new_status"
}

supersede_adr() {
    local old_number="$1"
    local new_number="$2"
    local old_filepath="$ADR_DIR/ADR-$(printf "%03d" "$old_number").md"
    local new_filepath="$ADR_DIR/ADR-$(printf "%03d" "$new_number").md"

    if [ ! -f "$old_filepath" ]; then
        echo "❌ ADR-$old_number not found"
        return 1
    fi

    if [ ! -f "$new_filepath" ]; then
        echo "❌ ADR-$new_number not found"
        return 1
    fi

    # Mark old ADR as superseded
    sed -i "s/^**Status:** .*/Status:** Superseded by ADR-$new_number/" "$old_filepath"

    # Add link to new ADR
    echo "" >> "$old_filepath"
    echo "**Superseded by:** [ADR-$new_number](ADR-$(printf "%03d" "$new_number").md)" >> "$old_filepath"

    echo "✅ ADR-$old_number marked as superseded by ADR-$new_number"
}

case "$COMMAND" in
    new)
        TITLE="${2:-}"
        [ -n "$TITLE" ] || { echo "Title required"; exit 1; }
        create_adr "$TITLE" "Proposed"
        ;;
    propose)
        TITLE="${2:-}"
        [ -n "$TITLE" ] || { echo "Title required"; exit 1; }
        create_adr "$TITLE" "Proposed"
        ;;
    list)
        list_adrs
        ;;
    status)
        NUMBER="${2:-}"
        [ -n "$NUMBER" ] || { echo "ADR number required"; exit 1; }
        show_status "$NUMBER"
        ;;
    accept)
        NUMBER="${2:-}"
        [ -n "$NUMBER" ] || { echo "ADR number required"; exit 1; }
        change_status "$NUMBER" "Accepted"
        ;;
    reject)
        NUMBER="${2:-}"
        [ -n "$NUMBER" ] || { echo "ADR number required"; exit 1; }
        change_status "$NUMBER" "Rejected"
        ;;
    supersede)
        OLD_NUMBER="${2:-}"
        NEW_NUMBER="${3:-}"
        [ -n "$OLD_NUMBER" ] && [ -n "$NEW_NUMBER" ] || { echo "Both old and new ADR numbers required"; exit 1; }
        supersede_adr "$OLD_NUMBER" "$NEW_NUMBER"
        ;;
    *)
        usage
        exit 1
        ;;
esac