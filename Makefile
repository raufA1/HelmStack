SHELL := /usr/bin/env bash
.SHELLFLAGS := -eo pipefail -c
.DEFAULT_GOAL := help

DOCS_DIR      ?= workspace
INCOMING_DIR  ?= $(DOCS_DIR)/incoming
PROCESSED_DIR ?= $(DOCS_DIR)/processed
PLANS_DIR     ?= $(DOCS_DIR)/plans
RESEARCH_DIR  ?= $(DOCS_DIR)/research
SNAP_DIR      ?= snapshots
MEM_DIR       ?= memory

NAME ?= $(notdir $(CURDIR))
DESC ?= Project initialized via HelmStack
DOC  ?=
GLOB ?=

go: start ## alias

start: ## 🔥 Full setup + smart start (optional DOC=path)
	@mkdir -p "$(INCOMING_DIR)" "$(PROCESSED_DIR)" "$(PLANS_DIR)" "$(RESEARCH_DIR)" "$(SNAP_DIR)"
	@if [ -n "$(DOC)" ]; then cp "$(DOC)" "$(INCOMING_DIR)/" && echo "✅ Added: $(DOC)"; fi
	@if [ ! -d .git ]; then git init && echo "ℹ️ git init"; fi
	@chmod +x scripts/*.sh 2>/dev/null || true
	@chmod +x scripts/*.py 2>/dev/null || true
	@if [ ! -f .helmstack_seeded ]; then pre-commit install || true; touch .helmstack_seeded; fi
	@bash scripts/smart_start.sh "$(NAME)" "$(DESC)" "$(DOCS_DIR)" "$(INCOMING_DIR)" "$(PLANS_DIR)"
	@echo "→ Next: make fix | make work | make done"

fix: plan ## 🧭 Refresh plan
	@bash scripts/ai_memory_refresh.sh "$(PLANS_DIR)" "$(MEM_DIR)"

work: ## 🎯 Build FOCUS_LIST from NEXT_STEPS
	@bash scripts/extract_next_steps.sh "$(PLANS_DIR)"
	@$(MAKE) plan
	@bash scripts/ai_memory_refresh.sh "$(PLANS_DIR)" "$(MEM_DIR)"

done: ## 🌅 End of day (snapshot + commit/tag/push; safe if no HEAD yet)
	@bash scripts/ai_memory_refresh.sh "$(PLANS_DIR)" "$(MEM_DIR)"
	@$(MAKE) eod

save: snapshot ## 💾 Snapshot only

plan: ## STATUS.md + NEXT_STEPS.md from docs
	@bash scripts/run_analyzer.sh "$(INCOMING_DIR)" "$(PLANS_DIR)"

resume: ## FOCUS_LIST from NEXT_STEPS
	@bash scripts/extract_next_steps.sh "$(PLANS_DIR)"

eod: ## snapshot + commit + tag + push (safe with no HEAD)
	@bash scripts/snapshot.sh "$(SNAP_DIR)"
	@echo "- $$(date '+%Y-%m-%d %H:%M') EOD checkpoint" >> SESSION_LOG.md
	@git add -A
	@git commit -m "chore(session): EOD checkpoint" --no-verify || true
	@git tag eod-$$(date '+%Y%m%d-%H%M') || true
	@git push || true
	@git push --tags || true

snapshot: ## Diff/log snapshot
	@bash scripts/snapshot.sh "$(SNAP_DIR)"

ask:   ## 🔎 Start research thread (TOPIC="...")
	@bash scripts/research.sh ask "$(RESEARCH_DIR)" "$(TOPIC)"
check: ## 🧪 Summarize findings for review
	@bash scripts/research.sh check "$(RESEARCH_DIR)"
yes:   ## ✅ Approve proposal
	@bash scripts/research.sh yes "$(RESEARCH_DIR)" "$(PLANS_DIR)" "$(MEM_DIR)"
no:    ## ✏️ Request changes
	@bash scripts/research.sh no "$(RESEARCH_DIR)"
end:   ## 🗂 Finalize research
	@bash scripts/research.sh end "$(RESEARCH_DIR)"

build: ## 🛠 Doc→README synthesizer
	@python3 scripts/autoplan.py "$(INCOMING_DIR)" "$(PLANS_DIR)" || true
ideas: ## 💡 Extract TODOs from docs
	@python3 scripts/autoplan.py --ideas "$(INCOMING_DIR)" "$(PLANS_DIR)" || true
epics: ## 🎯 Extract EPICs from docs
	@python3 scripts/autoplan.py --epics "$(INCOMING_DIR)" "$(PLANS_DIR)" || true
milestones: ## 🏆 Extract MILESTONEs from docs
	@python3 scripts/autoplan.py --milestones "$(INCOMING_DIR)" "$(PLANS_DIR)" || true
template: ## 📝 Generate template (TYPE=issue|todo|research|epic FILE=output.md)
	@bash scripts/templates.sh "$(TYPE)" "$(FILE)" || echo "Usage: make template TYPE=issue FILE=my-issue.md"
setup: ## ⚙️ GitHub bootstrap (via gh, optional)
	@bash scripts/bootstrap.sh || true

status: ## 📊 Show status
	@sed -n '1,80p' "$(PLANS_DIR)/STATUS.md" 2>/dev/null || echo "No STATUS.md yet"
next:   ## 📌 Show next steps
	@sed -n '1,80p' "$(PLANS_DIR)/NEXT_STEPS.md" 2>/dev/null || echo "No NEXT_STEPS.md yet"
focus:  ## 🎯 Show focus list
	@sed -n '1,80p' "$(PLANS_DIR)/FOCUS_LIST.md" 2>/dev/null || echo "No FOCUS_LIST.md yet"
log:    ## 📜 Show session log head
	@sed -n '1,120p' SESSION_LOG.md 2>/dev/null || echo "No SESSION_LOG yet"

clean:  ## 🧹 Clean generated
	@rm -rf "$(SNAP_DIR)"/* 2>/dev/null || true
	@find "$(PLANS_DIR)" -name "FOCUS_LIST.md" -delete 2>/dev/null || true
	@echo "Cleaned snapshots and focus list."

commit: ## 📝 Commit changes (MSG="...")
	@[ -n "$(MSG)" ] || (echo "MSG is required: make commit MSG='...'" && exit 1)
	@git add -A && git commit -m "$(MSG)"
push:   ## ⬆️ Push and tags
	@git push || true
	@git push --tags || true

help:   ## Show help
	@echo ""; echo "🚀 HelmStack Commands"; echo ""
	@grep -E '^[a-zA-Z0-9_-]+:.*?## ' Makefile | sed -E 's/:.*?## /  - /'
	@echo ""; echo "Docs: $(PLANS_DIR) | Input: $(INCOMING_DIR) | Memory: $(MEM_DIR)"; echo ""

.PHONY: start go fix work done save plan resume eod snapshot ask check yes no end build ideas setup status next focus log clean commit push help