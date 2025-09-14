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

eod: ## ✅ End of day - snapshot + git commit/tag/push (safe with no HEAD)
	@bash scripts/eod.sh "$(SNAP_DIR)" "$(PLANS_DIR)"

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
analyze: ## 🔍 Analyze documents (ANALYZER=markdown|risk|scope PATH=file/dir)
	@python3 scripts/analyze.py "$(PATH)" $(if $(ANALYZER),--analyzers $(ANALYZER),) || echo "Usage: make analyze PATH=workspace/incoming"
analyzers: ## 📋 List available analyzers
	@python3 scripts/analyze.py --list-analyzers workspace/incoming
template: ## 📝 Generate template (TYPE=issue|todo|research|epic FILE=output.md)
	@bash scripts/templates.sh "$(TYPE)" "$(FILE)" || echo "Usage: make template TYPE=issue FILE=my-issue.md"
adr-new: ## 📋 Create new ADR (TITLE="Decision title")
	@bash scripts/adr.sh new "$(TITLE)" || echo "Usage: make adr-new TITLE='Use PostgreSQL for database'"
adr-list: ## 📋 List all ADRs
	@bash scripts/adr.sh list
adr-accept: ## ✅ Accept ADR (NUM=001)
	@bash scripts/adr.sh accept "$(NUM)" || echo "Usage: make adr-accept NUM=001"
adr-status: ## 📊 Show ADR status (NUM=001)
	@bash scripts/adr.sh status "$(NUM)" || echo "Usage: make adr-status NUM=001"
analytics: ## 📊 Show today's session analytics
	@python3 scripts/analytics.py || echo "No session data available"
trends: ## 📈 Show productivity trends (DAYS=7)
	@python3 scripts/analytics.py --trends $(or $(DAYS),7) || echo "Usage: make trends DAYS=7"
extract: ## 📄 Extract text from PDF/DOCX (FILE=input.pdf OUTPUT=output.md)
	@python3 scripts/extract_text.py "$(FILE)" $(if $(OUTPUT),-o "$(OUTPUT)",) || echo "Usage: make extract FILE=doc.pdf OUTPUT=doc.md"
setup: ## ⚙️ GitHub bootstrap (via gh, optional)
	@bash scripts/bootstrap.sh || true

status: ## 📊 Show status
	@sed -n '1,80p' "$(PLANS_DIR)/STATUS.md" 2>/dev/null || echo "No STATUS.md yet"
next:   ## 📌 Show next steps
	@sed -n '1,80p' "$(PLANS_DIR)/NEXT_STEPS.md" 2>/dev/null || echo "No NEXT_STEPS.md yet"
focus:  ## 🎯 Show focus list
	@sed -n '1,80p' "$(PLANS_DIR)/FOCUS_LIST.md" 2>/dev/null || echo "No FOCUS_LIST.md yet"
memory: ## 🧠 Show AI memory summary
	@bash scripts/ai_memory_refresh.sh "$(PLANS_DIR)" "$(MEM_DIR)" "$(RESEARCH_DIR)"
	@cat "$(MEM_DIR)/MEMORY.md" 2>/dev/null || echo "No memory summary yet"
context: ## 🎯 Show quick context
	@bash scripts/ai_memory_refresh.sh "$(PLANS_DIR)" "$(MEM_DIR)" "$(RESEARCH_DIR)" >/dev/null
	@cat "$(MEM_DIR)/CONTEXT.md" 2>/dev/null || echo "No context yet"
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

help:   ## 📖 Show colorful help
	@bash scripts/help.sh

version: ## 📋 Show HelmStack version
	@echo "🚀 HelmStack v1.0.0-M5"
	@echo "Document-first, AI-powered project flow"
	@echo "Repository: https://github.com/raufA1/HelmStack"

fix-lint: ## 🔧 Fix linting issues
	@echo "🔧 Running ruff with auto-fix..."
	@ruff check scripts/ --fix || echo "Install ruff: pip install ruff"
	@echo "✅ Linting fixes applied"

fix-format: ## 🎨 Fix code formatting
	@echo "🎨 Running black formatter..."
	@black scripts/ || echo "Install black: pip install black"
	@echo "✅ Code formatting applied"

fix-yaml: ## 📝 Fix YAML formatting
	@echo "📝 Checking YAML files..."
	@yamllint .github/workflows/ .pre-commit-config.yaml || echo "Install yamllint: pip install yamllint"
	@echo "✅ YAML files checked"

gh-create: ## 🏗️ Create GitHub repository (PRIVATE=true/false)
	@echo "🏗️ Creating GitHub repository..."
	@if [ "$(PRIVATE)" = "true" ]; then \
		gh repo create --private $(NAME) --description "$(DESC)" --clone=false; \
	else \
		gh repo create --public $(NAME) --description "$(DESC)" --clone=false; \
	fi
	@git remote add origin git@github.com:$(shell gh auth status | grep 'Logged in' | cut -d' ' -f6)/$(NAME).git
	@echo "✅ Repository created and remote added"

gh-push: ## 🚀 Initial push to GitHub
	@echo "🚀 Pushing to GitHub..."
	@git push -u origin main
	@echo "✅ Pushed to GitHub"

pr: ## 📋 Create Pull Request
	@echo "📋 Creating Pull Request..."
	@gh pr create --title "$(TITLE)" --body "$(BODY)" || echo "Usage: make pr TITLE='Title' BODY='Description'"

analyzers: ## 🔍 List available analyzers
	@python3 scripts/analyze.py --list-analyzers workspace/incoming

blockers: ## 🚫 Show blockers from analysis
	@python3 scripts/analyze.py --blockers workspace/incoming workspace/plans
	@cat workspace/plans/BLOCKERS.md 2>/dev/null || echo "No blockers identified"

productivity: ## 📊 Real productivity metrics
	@echo "📊 Productivity Metrics"
	@python3 scripts/analytics.py --productivity || echo "No session data available"

timeline: ## 📅 Project timeline
	@echo "📅 Project Timeline"
	@if [ -d .git ]; then git log --oneline --graph --decorate; else echo "Not a git repository"; fi

dependencies: ## 🔗 Dependency analysis
	@echo "🔗 Analyzing dependencies..."
	@python3 scripts/analyze.py --dependencies workspace/incoming workspace/plans
	@cat workspace/plans/DEPENDENCIES.md 2>/dev/null || echo "No dependencies analyzed"

.PHONY: start go fix work done save plan resume eod snapshot ask check yes no end build ideas setup status next focus log clean commit push help version fix-lint fix-format fix-yaml gh-create gh-push pr analyzers blockers productivity timeline dependencies
