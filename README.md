# HelmStack

A single, elastic repository that plans, tracks, and orchestrates work like a professional PM — **document-first**, **repo-as-memory**, and **human-in-the-loop** research.

## Quick Start
```bash
# put any docs into workspace/incoming/*.md
make start NAME="My Project" DESC="One-liner" DOC=spec.md
make fix
make work
# ...do tasks...
make done
```

## Folders

workspace/incoming/ – your source docs (md/docx/pdf)

workspace/plans/ – generated plan: STATUS.md, NEXT_STEPS.md, FOCUS_LIST.md

workspace/research/ – research threads (ask/check/yes/no/end)

workspace/processed/ – archived inputs

memory/ – repo memory (SUMMARY.md, DECISIONS.md, …)

snapshots/ – EOD and manual snapshots

scripts/ – all helpers (bash/python)