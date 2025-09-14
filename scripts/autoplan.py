#!/usr/bin/env python3
import sys, re, pathlib
def read(p):
    try: return pathlib.Path(p).read_text(encoding="utf-8")
    except: return ""

def ideas(text):
    return ["- [ ] " + re.sub(r"^\s*[-*]\s+","",ln).strip()
            for ln in text.splitlines() if re.match(r"^\s*[-*]\s+", ln)]

def extract_epics(text):
    """Extract epic-level headings (## Epic: ... or ## ...)"""
    epics = []
    for line in text.splitlines():
        if re.match(r"^##\s+Epic:\s*", line):
            epic_name = re.sub(r"^##\s+Epic:\s*", "", line).strip()
            epics.append(f"- Epic: {epic_name}")
        elif re.match(r"^##\s+", line):
            heading = re.sub(r"^##\s+", "", line).strip()
            if not heading.lower().startswith(('status', 'summary', 'overview', 'notes', 'background')):
                epics.append(f"- Epic: {heading}")
    return epics

def extract_milestones(text):
    """Extract milestone headings (## M1: ... or ## Milestone ...)"""
    milestones = []
    for line in text.splitlines():
        if re.match(r"^##\s+M\d+:\s*", line):
            milestone = re.sub(r"^##\s+", "", line).strip()
            milestones.append(f"- {milestone}")
        elif re.match(r"^##\s+Milestone\s*", line):
            milestone = re.sub(r"^##\s+", "", line).strip()
            milestones.append(f"- {milestone}")
    return milestones

def add_epic_tags(text):
    """Add @epic:NAME tags to tasks that appear under epic headings"""
    lines = text.splitlines()
    result = []
    current_epic = None

    for line in lines:
        # Check if this is an epic heading
        if re.match(r"^##\s+", line):
            epic_name = re.sub(r"^##\s+", "", line).strip()
            if not epic_name.lower().startswith(('status', 'summary', 'overview', 'notes', 'background')):
                current_epic = epic_name.replace(" ", "_").lower()

        # Add epic tag to tasks
        if current_epic and re.match(r"^\s*[-*]\s+", line):
            task = re.sub(r"^\s*[-*]\s+", "- [ ] ", line).strip()
            if not f"@epic:{current_epic}" in task:
                task += f" @epic:{current_epic}"
            result.append(task)
        elif re.match(r"^\s*[-*]\s+", line):
            result.append("- [ ] " + re.sub(r"^\s*[-*]\s+", "", line).strip())

    return result

def merge_ideas_idempotent(existing_content, new_ideas):
    """Merge new ideas with existing NEXT_STEPS without duplicates"""
    lines = existing_content.splitlines()

    # Find existing tasks
    existing_tasks = set()
    for line in lines:
        if line.strip().startswith("- [ ] "):
            task_text = line.strip()[6:].strip()  # Remove "- [ ] " prefix
            existing_tasks.add(task_text.lower())

    # Add new unique tasks
    new_tasks = []
    for idea in new_ideas:
        task_text = idea[6:].strip()  # Remove "- [ ] " prefix
        if task_text.lower() not in existing_tasks:
            new_tasks.append(idea)
            existing_tasks.add(task_text.lower())

    # Append new tasks to existing content
    if new_tasks:
        if not existing_content.strip().endswith('\n'):
            existing_content += '\n'
        existing_content += '\n'.join(new_tasks) + '\n'

    return existing_content

def main():
    import argparse; ap=argparse.ArgumentParser()
    ap.add_argument("--ideas", action="store_true")
    ap.add_argument("--epics", action="store_true")
    ap.add_argument("--milestones", action="store_true")
    ap.add_argument("incoming", nargs="?", default="workspace/incoming")
    ap.add_argument("plans",    nargs="?", default="workspace/plans")
    a=ap.parse_args(); inc=pathlib.Path(a.incoming); pl=pathlib.Path(a.plans); pl.mkdir(parents=True, exist_ok=True)
    docs = sorted(inc.glob("*.md"));
    if not docs: print("autoplan: no docs"); return

    # Combine all docs text for analysis
    combined_text = "\n".join([read(d) for d in docs])

    if a.epics:
        # Extract epics and save to EPICS.md
        epics = extract_epics(combined_text)
        epics_file = pl/"EPICS.md"
        content = "# EPICS\n\n" + "\n".join(epics) + "\n"
        epics_file.write_text(content, encoding="utf-8")
        print(f"autoplan: EPICS.md updated with {len(epics)} epics"); return

    if a.milestones:
        # Extract milestones and save to MILESTONES.md
        milestones = extract_milestones(combined_text)
        milestones_file = pl/"MILESTONES.md"
        content = "# MILESTONES\n\n" + "\n".join(milestones) + "\n"
        milestones_file.write_text(content, encoding="utf-8")
        print(f"autoplan: MILESTONES.md updated with {len(milestones)} milestones"); return

    if a.ideas:
        # Extract ideas with epic tags
        todo = add_epic_tags(combined_text)
        if not todo:
            todo = []
            [todo.extend(ideas(read(d))) for d in docs]

        # Read existing NEXT_STEPS.md if it exists
        next_steps_file = pl/"NEXT_STEPS.md"
        if next_steps_file.exists():
            existing_content = next_steps_file.read_text(encoding="utf-8")
            updated_content = merge_ideas_idempotent(existing_content, todo)
        else:
            updated_content = "# NEXT_STEPS\n\n" + "\n".join(todo) + "\n"

        next_steps_file.write_text(updated_content, encoding="utf-8")
        print(f"autoplan: NEXT_STEPS updated with {len(todo)} ideas"); return

    out = ["# Project\n\n## Overview\n\n"] + [f"# Source: {d.name}\n{read(d)}\n---\n" for d in docs]
    pathlib.Path("README.md").write_text("".join(out), encoding="utf-8"); print("autoplan: README synthesized")

if __name__ == "__main__": main()