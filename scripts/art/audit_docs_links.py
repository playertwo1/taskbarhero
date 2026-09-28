import os
import re

PROJECT_ROOT = os.path.abspath(".")
DOCS_DIR = os.path.join(PROJECT_ROOT, "docs")

all_mds = set()
for root, dirs, files in os.walk(PROJECT_ROOT):
    if any(x in root for x in [".git", ".godot", "Pixelorama", "Aseprite", "tools", "build", ".codex-remote-attachments"]):
        continue
    for f in files:
        if f.endswith(".md"):
            all_mds.add(os.path.normpath(os.path.join(root, f)))

links_found = set()
broken_links = []
link_re = re.compile(r'\[([^\]]+)\]\(([^)]+)\)')

for md_path in all_mds:
    try:
        with open(md_path, "r", encoding="utf-8") as f:
            content = f.read()
    except Exception as e:
        continue
    
    dir_path = os.path.dirname(md_path)
    for text, url in link_re.findall(content):
        if url.startswith(("http://", "https://", "mailto:", "#")):
            continue
        clean_url = url.split("#")[0].split("?")[0]
        if not clean_url:
            continue
        
        target = os.path.normpath(os.path.join(dir_path, clean_url))
        links_found.add(target)
        if not os.path.exists(target):
            rel_src = os.path.relpath(md_path, PROJECT_ROOT)
            broken_links.append((rel_src, url, target))

print(f"Total de arquivos MD analisados: {len(all_mds)}")
print(f"Total de links quebrados encontrados: {len(broken_links)}")
for src, url, tgt in broken_links:
    print(f"  Em [{src}]: link '({url})' -> destino não existe!")

unref = []
for md in all_mds:
    if md not in links_found:
        rel = os.path.relpath(md, PROJECT_ROOT)
        # ignore root files like README, AGENTS, etc.
        if not os.path.basename(md) in ["README.md", "AGENTS.md", "INDEX.md"]:
            unref.append(rel)

print(f"\nTotal de arquivos MD sem nenhum link de entrada (órfãos): {len(unref)}")
for u in sorted(unref):
    print(f"  Órfão: {u}")
