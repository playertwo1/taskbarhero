import os
import subprocess
import shutil

PROJECT_ROOT = os.path.abspath(".")
MOCKUPS_DIR = os.path.join(PROJECT_ROOT, "docs", "art", "mockups")
BRAIN_DIR = r"C:\Users\notefael\.gemini\antigravity\brain\a967aa1b-4428-4099-947a-ad6f69740286"
WORK_DIR = os.path.join(PROJECT_ROOT, "work", "ui_shots")
os.makedirs(WORK_DIR, exist_ok=True)

EDGE_PATH = r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
TEMP_USER_DATA = os.path.join(os.environ.get("TEMP", "C:/Temp"), "edge_shot_profile")

HTML_SOURCE = os.path.join(MOCKUPS_DIR, "core_screens_options.html")
with open(HTML_SOURCE, "r", encoding="utf-8") as f:
    full_html = f.read()

# CSS & Head extraction
head_end = full_html.find("</head>")
head_part = full_html[:head_end]

screens = [
    ("hub", "preview_hub_options.png", "1. O Hub / O Refúgio — 3 Opções de Interface"),
    ("fases", "preview_fases_options.png", "2. Seleção de Fases (Bosque de Lúmen) — 3 Opções"),
    ("titulo", "preview_titulo_options.png", "3. Tela Inicial (Título & Retorno) — 3 Opções"),
    ("loadout", "preview_loadout_options.png", "4. Loadout da Party (Skills & Itens) — 3 Opções"),
]

for screen_id, png_name, title in screens:
    # Find start and end of screen block
    start_tag = f'<div id="screen-{screen_id}" class="screen-view'
    start_idx = full_html.find(start_tag)
    if start_idx == -1:
        print(f"Error: screen-{screen_id} not found!")
        continue
    
    # Extract inner content up to next screen or script
    # Look for closing of screen-view
    # In full_html, each screen-view ends before next <!-- === or <script>
    next_comment = full_html.find("<!-- ===", start_idx + len(start_tag))
    if next_comment == -1:
        next_comment = full_html.find("<script>", start_idx)
    
    screen_block = full_html[start_idx:next_comment].strip()
    # Remove 'hidden' class if present
    screen_block = screen_block.replace('class="screen-view hidden"', 'class="screen-view"')

    # Build standalone html
    shot_html = f"""<!doctype html>
<html lang="pt-BR">
{head_part}
</head>
<body class="antialiased" style="background: #0b0f12; padding: 18px 24px; color: #f0ece1;">
  <div style="max-width: 1140px; margin: 0 auto 14px; display: flex; justify-content: space-between; align-items: flex-end; border-bottom: 1px solid #243238; padding-bottom: 10px;">
    <div>
      <span class="pixel-badge" style="background: #193328; color: #7ec4a8; border: 1px solid #2b5946;">Pocket Hero Mobile</span>
      <h2 style="font-size: 20px; font-weight: 800; margin: 4px 0 0; color: #f0ece1;">{title}</h2>
    </div>
    <div style="font-size: 11px; color: #8ba098;">1080×2340 Mobile Form Factor · Opções A, B e C</div>
  </div>
  <div style="max-width: 1140px; margin: 0 auto;">
    {screen_block}
  </div>
</body>
</html>
"""
    shot_file = os.path.join(WORK_DIR, f"shot_{screen_id}.html")
    with open(shot_file, "w", encoding="utf-8") as sf:
        sf.write(shot_html)
    
    out_png_mockups = os.path.join(MOCKUPS_DIR, png_name)
    out_png_brain = os.path.join(BRAIN_DIR, png_name)
    
    # Run Edge headless screenshot
    url = f"file:///{os.path.abspath(shot_file).replace(os.sep, '/')}"
    cmd = [
        EDGE_PATH,
        "--headless",
        "--disable-gpu",
        f"--user-data-dir={TEMP_USER_DATA}",
        f"--screenshot={out_png_mockups}",
        "--window-size=1200,840",
        "--hide-scrollbars",
        url
    ]
    
    print(f"Capturing screenshot for {screen_id} -> {png_name}...")
    res = subprocess.run(cmd, capture_output=True, text=True)
    if os.path.exists(out_png_mockups):
        size = os.path.getsize(out_png_mockups)
        print(f"  [OK] {png_name} gerado com sucesso ({size} bytes)")
        shutil.copyfile(out_png_mockups, out_png_brain)
        print(f"  [OK] Copiado para artifact dir: {out_png_brain}")
    else:
        print(f"  [FAIL] Falha ao gerar {png_name}: {res.stderr}")

print("\nRenderizacao de todas as telas concluida!")
