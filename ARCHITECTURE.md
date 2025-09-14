# Architecture

helmstack/
├─ Makefile
├─ scripts/ # shell & python helpers
├─ workspace/
│ ├─ incoming/ # input docs
│ ├─ processed/ # archived inputs
│ ├─ plans/ # STATUS.md / NEXT_STEPS.md / FOCUS_LIST.md
│ └─ research/ # proposals, notes, decisions
├─ memory/ # SUMMARY.md / DECISIONS.md / OPEN_QUESTIONS.md / GLOSSARY.md
├─ snapshots/ # EOD snapshots
└─ .github/workflows/ # optional CI (docs lint)

**Pipelines**
- Planning: `incoming/*.md` → `scripts/run_analyzer.sh` → `plans/*`
- Focus: `scripts/extract_next_steps.sh` → `FOCUS_LIST.md`
- Research (HITL): `scripts/research.sh` → proposals → approval → `NEXT_STEPS`
- Memory: `scripts/ai_memory_refresh.sh` → `memory/SUMMARY.md`
- EOD: `scripts/snapshot.sh` (+ commit/tag/push)