import os
import base64

ARTIFACT_DIR = r"C:\Users\notefael\.gemini\antigravity\brain\a967aa1b-4428-4099-947a-ad6f69740286"
IMG_PATH = os.path.join(ARTIFACT_DIR, "preview_party_heroes.png")
OUT_HTML = os.path.join(ARTIFACT_DIR, "party_preview.html")

with open(IMG_PATH, "rb") as f:
    img_b64 = base64.b64encode(f.read()).decode("utf-8")

html_content = f"""<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <title>Pocket Hero - Trio de Heróis</title>
  <script src="https://www.gstatic.com/antigravity/web/dev/tailwindcss.min.js"></script>
  <style>
    .pixelated {{
      image-rendering: pixelated;
      image-rendering: -moz-crisp-edges;
      image-rendering: crisp-edges;
    }}
  </style>
</head>
<body class="bg-transparent text-[var(--foreground)] antialiased p-3">
  <div class="bg-[var(--card)] text-[var(--foreground)] border border-[var(--border)] rounded-xl p-4 shadow-lg max-w-2xl mx-auto">
    <!-- Header -->
    <div class="flex items-center justify-between pb-3 border-b border-[var(--border)] mb-3">
      <div>
        <div class="flex items-center gap-2">
          <span class="inline-block w-2.5 h-2.5 rounded-full bg-emerald-500 animate-pulse"></span>
          <h2 class="font-bold text-base text-[var(--foreground)]">Pocket Hero — Trio de Heróis (MVP)</h2>
        </div>
        <p class="text-xs text-[var(--muted-foreground)]">Formação Canônica da Party: Flecha (Back), Íris (Mid) e Bastião (Front)</p>
      </div>
      <span class="px-2.5 py-1 text-xs rounded font-medium bg-emerald-600/20 text-emerald-400 border border-emerald-500/30">
        Passos 1-4 PASS
      </span>
    </div>

    <!-- Tela do Jogo (AMOLED Preview) -->
    <div class="relative rounded-lg overflow-hidden border border-[#1e3025] bg-[#060807] shadow-inner flex items-center justify-center p-1">
      <img src="data:image/png;base64,{img_b64}" alt="Trio de Heróis Pocket Hero" class="pixelated w-full h-auto rounded block" />
    </div>

    <!-- Indicadores dos 3 Heróis -->
    <div class="grid grid-cols-3 gap-2 mt-3 pt-3 border-t border-[var(--border)] text-center">
      <div class="p-2 rounded bg-[var(--muted)]/50 border border-emerald-500/20">
        <div class="text-[10px] uppercase font-semibold text-emerald-400">Back — DPS Físico</div>
        <div class="text-xs font-bold text-[var(--foreground)] mt-0.5">Flecha</div>
        <div class="text-[10px] text-[var(--muted-foreground)]">Arco & Couro Silvestre</div>
      </div>
      <div class="p-2 rounded bg-[var(--muted)]/50 border border-purple-500/20">
        <div class="text-[10px] uppercase font-semibold text-purple-400">Mid — DPS Mágico</div>
        <div class="text-xs font-bold text-[var(--foreground)] mt-0.5">Íris</div>
        <div class="text-[10px] text-[var(--muted-foreground)]">Cajado & Orbe de Lúmen</div>
      </div>
      <div class="p-2 rounded bg-[var(--muted)]/50 border border-blue-500/20">
        <div class="text-[10px] uppercase font-semibold text-sky-400">Front — Tanque</div>
        <div class="text-xs font-bold text-[var(--foreground)] mt-0.5">Bastião</div>
        <div class="text-[10px] text-[var(--muted-foreground)]">Escudo & Armadura de Aço</div>
      </div>
    </div>
  </div>
</body>
</html>
"""

with open(OUT_HTML, "w", encoding="utf-8") as f:
    f.write(html_content)

print("Party HTML salvo em:", OUT_HTML)
