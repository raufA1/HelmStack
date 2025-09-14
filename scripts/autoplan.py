#!/usr/bin/env python3
import sys, re, pathlib
def read(p):
    try: return pathlib.Path(p).read_text(encoding="utf-8")
    except: return ""
def ideas(text):
    return ["- [ ] " + re.sub(r"^\s*[-*]\s+","",ln).strip()
            for ln in text.splitlines() if re.match(r"^\s*[-*]\s+", ln)]
def main():
    import argparse; ap=argparse.ArgumentParser()
    ap.add_argument("--ideas", action="store_true")
    ap.add_argument("incoming", nargs="?", default="workspace/incoming")
    ap.add_argument("plans",    nargs="?", default="workspace/plans")
    a=ap.parse_args(); inc=pathlib.Path(a.incoming); pl=pathlib.Path(a.plans); pl.mkdir(parents=True, exist_ok=True)
    docs = sorted(inc.glob("*.md"));
    if not docs: print("autoplan: no docs"); return
    if a.ideas:
        todo=[]; [todo.extend(ideas(read(d))) for d in docs]
        (pl/"NEXT_STEPS.md").write_text("# NEXT_STEPS\n\n"+"\n".join(todo)+"\n", encoding="utf-8");
        print("autoplan: NEXT_STEPS updated"); return
    out = ["# Project\n\n## Overview\n\n"] + [f"# Source: {d.name}\n{read(d)}\n---\n" for d in docs]
    pathlib.Path("README.md").write_text("".join(out), encoding="utf-8"); print("autoplan: README synthesized")
if __name__ == "__main__": main()