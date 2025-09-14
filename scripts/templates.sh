#!/usr/bin/env bash
set -euo pipefail

TEMPLATE_TYPE="${1:-}"
OUTPUT_FILE="${2:-}"
TEMPLATES_DIR="${3:-templates}"

usage() {
    echo "Usage: templates.sh [issue|todo|research|epic] [output-file]"
    echo ""
    echo "Templates:"
    echo "  issue     - GitHub issue template"
    echo "  todo      - TODO block template"
    echo "  research  - Research proposal template"
    echo "  epic      - Epic specification template"
    echo ""
    echo "Examples:"
    echo "  templates.sh issue new-feature.md"
    echo "  templates.sh todo workspace/incoming/tasks.md"
    echo "  templates.sh research workspace/research/20250914-123456/proposal.md"
}

prompt_value() {
    local prompt="$1"
    local default="${2:-}"
    local value

    if [ -n "$default" ]; then
        read -p "$prompt [$default]: " value
        echo "${value:-$default}"
    else
        read -p "$prompt: " value
        echo "$value"
    fi
}

generate_issue_template() {
    local output="$1"

    echo "🎯 Creating GitHub Issue Template"
    echo

    TASK_TITLE=$(prompt_value "Task title")
    TASK_DESCRIPTION=$(prompt_value "Task description")
    EPIC_NAME=$(prompt_value "Epic name" "General")
    PRIORITY=$(prompt_value "Priority" "Medium")
    ESTIMATE=$(prompt_value "Estimate" "TBD")

    # Read template and substitute
    sed -e "s/{TASK_TITLE}/$TASK_TITLE/g" \
        -e "s/{TASK_DESCRIPTION}/$TASK_DESCRIPTION/g" \
        -e "s/{EPIC_NAME}/$EPIC_NAME/g" \
        -e "s/{PRIORITY}/$PRIORITY/g" \
        -e "s/{ESTIMATE}/$ESTIMATE/g" \
        -e "s/{CRITERIA_1}/First acceptance criteria/g" \
        -e "s/{CRITERIA_2}/Second acceptance criteria/g" \
        -e "s/{CRITERIA_3}/Third acceptance criteria/g" \
        -e "s/{EPIC_TAG}/$(echo $EPIC_NAME | tr '[:upper:]' '[:lower:]' | tr ' ' '-')/g" \
        -e "s/{PRIORITY_TAG}/$(echo $PRIORITY | tr '[:upper:]' '[:lower:]')/g" \
        -e "s/{ADDITIONAL_NOTES}/Add any additional notes here/g" \
        "$TEMPLATES_DIR/issue_task.md" > "$output"

    echo "✅ Issue template created: $output"
}

generate_todo_template() {
    local output="$1"

    echo "📋 Creating TODO Block Template"
    echo

    BLOCK_TITLE=$(prompt_value "TODO block title")
    EPIC_NAME=$(prompt_value "Epic name" "General")
    PRIORITY=$(prompt_value "Priority" "Medium")

    sed -e "s/{BLOCK_TITLE}/$BLOCK_TITLE/g" \
        -e "s/{EPIC_NAME}/$EPIC_NAME/g" \
        -e "s/{PRIORITY}/$PRIORITY/g" \
        -e "s/{ESTIMATE}/TBD/g" \
        -e "s/{TASK_1}/First task/g" \
        -e "s/{TASK_2}/Second task/g" \
        -e "s/{TASK_3}/Third task/g" \
        -e "s/{DEPENDENCY_1}/First dependency/g" \
        -e "s/{DEPENDENCY_2}/Second dependency/g" \
        -e "s/{NOTES}/Add notes here/g" \
        "$TEMPLATES_DIR/todo_block.md" > "$output"

    echo "✅ TODO template created: $output"
}

generate_research_template() {
    local output="$1"

    echo "🔬 Creating Research Proposal Template"
    echo

    TOPIC=$(prompt_value "Research topic")
    DATE=$(date '+%Y-%m-%d')

    sed -e "s/{TOPIC}/$TOPIC/g" \
        -e "s/{DATE}/$DATE/g" \
        -e "s/{BACKGROUND_CONTEXT}/Describe the background context/g" \
        -e "s/{PROBLEM_DESCRIPTION}/Describe the problem/g" \
        -e "s/{SOLUTION_DESCRIPTION}/Describe the proposed solution/g" \
        -e "s/{OPTION_A}/First option/g" \
        -e "s/{PROS_A}/Advantages of option A/g" \
        -e "s/{CONS_A}/Disadvantages of option A/g" \
        -e "s/{OPTION_B}/Second option/g" \
        -e "s/{PROS_B}/Advantages of option B/g" \
        -e "s/{CONS_B}/Disadvantages of option B/g" \
        -e "s/{RECOMMENDATION}/Recommended approach/g" \
        -e "s/{TECHNICAL_IMPACT}/Technical impact assessment/g" \
        -e "s/{BUSINESS_IMPACT}/Business impact assessment/g" \
        -e "s/{RISK_ASSESSMENT}/Risk assessment/g" \
        -e "s/{NEXT_STEP_1}/First next step/g" \
        -e "s/{NEXT_STEP_2}/Second next step/g" \
        -e "s/{NEXT_STEP_3}/Third next step/g" \
        -e "s/{REFERENCE_1}/First reference/g" \
        -e "s/{REFERENCE_2}/Second reference/g" \
        "$TEMPLATES_DIR/research_proposal.md" > "$output"

    echo "✅ Research template created: $output"
}

generate_epic_template() {
    local output="$1"

    echo "🎯 Creating Epic Specification Template"
    echo

    EPIC_NAME=$(prompt_value "Epic name")
    EPIC_ID=$(date '+%Y%m%d')
    OWNER=$(prompt_value "Epic owner" "$(whoami)")

    sed -e "s/{EPIC_NAME}/$EPIC_NAME/g" \
        -e "s/{EPIC_ID}/$EPIC_ID/g" \
        -e "s/{STATUS}/Planning/g" \
        -e "s/{OWNER}/$OWNER/g" \
        -e "s/{TARGET_MILESTONE}/TBD/g" \
        -e "s/{EPIC_DESCRIPTION}/Describe the epic goals and scope/g" \
        -e "s/{USER_TYPE}/user type/g" \
        -e "s/{GOAL}/goal/g" \
        -e "s/{BENEFIT}/benefit/g" \
        -e "s/{METRIC_1}/First success metric/g" \
        -e "s/{METRIC_2}/Second success metric/g" \
        -e "s/{METRIC_3}/Third success metric/g" \
        -e "s/{PLANNING_TASK_1}/First planning task/g" \
        -e "s/{PLANNING_TASK_2}/Second planning task/g" \
        -e "s/{IMPL_TASK_1}/First implementation task/g" \
        -e "s/{IMPL_TASK_2}/Second implementation task/g" \
        -e "s/{IMPL_TASK_3}/Third implementation task/g" \
        -e "s/{TEST_TASK_1}/First testing task/g" \
        -e "s/{TEST_TASK_2}/Second testing task/g" \
        -e "s/{DEPENDENCY_1}/First dependency/g" \
        -e "s/{DEPENDENCY_2}/Second dependency/g" \
        -e "s/{RISK_1}/First risk/g" \
        -e "s/{MITIGATION_1}/Risk mitigation strategy/g" \
        -e "s/{ADDITIONAL_NOTES}/Additional notes/g" \
        "$TEMPLATES_DIR/epic_spec.md" > "$output"

    echo "✅ Epic template created: $output"
}

case "$TEMPLATE_TYPE" in
    issue)
        [ -z "$OUTPUT_FILE" ] && OUTPUT_FILE="issue-$(date '+%Y%m%d-%H%M%S').md"
        generate_issue_template "$OUTPUT_FILE"
        ;;
    todo)
        [ -z "$OUTPUT_FILE" ] && OUTPUT_FILE="todo-$(date '+%Y%m%d-%H%M%S').md"
        generate_todo_template "$OUTPUT_FILE"
        ;;
    research)
        [ -z "$OUTPUT_FILE" ] && OUTPUT_FILE="research-$(date '+%Y%m%d-%H%M%S').md"
        generate_research_template "$OUTPUT_FILE"
        ;;
    epic)
        [ -z "$OUTPUT_FILE" ] && OUTPUT_FILE="epic-$(date '+%Y%m%d-%H%M%S').md"
        generate_epic_template "$OUTPUT_FILE"
        ;;
    *)
        usage
        exit 1
        ;;
esac