import os
import json

ARTIFACT_DIR = r"C:\Users\notefael\.gemini\antigravity\brain\a967aa1b-4428-4099-947a-ad6f69740286"
JSON_PATH = os.path.join(ARTIFACT_DIR, "preview_base64.json")
OUT_HTML = os.path.join(ARTIFACT_DIR, "battle_preview.html")

with open(JSON_PATH, "r", encoding="utf-8") as f:
    data = json.load(f)

gif_b64 = data["gif_b64"]
png_b64 = data["png_b64"]

html_content = f"""<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <title>Pocket Hero - Visual Preview</title>
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
          <h2 class="font-bold text-base text-[var(--foreground)]">Pocket Hero — Bosque de Lúmen</h2>
        </div>
        <p class="text-xs text-[var(--muted-foreground)]">Gate R11: Bastião (48×48) vs Geleia de Lúmen (32×32) no BattleStrip AMOLED</p>
      </div>
      <div class="flex gap-1.5">
        <button id="btn-gif" onclick="showMedia('gif')" class="px-2.5 py-1 text-xs rounded font-medium bg-emerald-600 text-white hover:bg-emerald-500 transition">
          ▶ Loop Animado
        </button>
        <button id="btn-png" onclick="showMedia('png')" class="px-2.5 py-1 text-xs rounded font-medium bg-[var(--muted)] text-[var(--foreground)] hover:bg-zinc-700 transition">
          ⏸ Idle Estático
        </button>
      </div>
    </div>

    <!-- Tela do Jogo (AMOLED Preview) -->
    <div class="relative rounded-lg overflow-hidden border border-[#1e3025] bg-[#060807] shadow-inner flex items-center justify-center p-1">
      <img id="view-gif" src="data:image/gif;base64,{gif_b64}" alt="Loop de Combate Pocket Hero" class="pixelated w-full h-auto rounded block" />
      <img id="view-png" src="data:image/png;base64,{png_b64}" alt="Idle Pocket Hero" class="pixelated w-full h-auto rounded hidden" />
    </div>

    <!-- Indicadores Técnicos -->
    <div class="grid grid-cols-3 gap-2 mt-3 pt-3 border-t border-[var(--border)] text-center">
      <div class="p-2 rounded bg-[var(--muted)]/50">
        <div class="text-[10px] uppercase font-semibold text-[var(--muted-foreground)]">Proporção (2.0×)</div>
        <div class="text-xs font-bold text-emerald-400 mt-0.5">Herói 48² / Mob 32²</div>
        <div class="text-[10px] text-[var(--muted-foreground)]">0 Mixels • Grid Fixo</div>
      </div>
      <div class="p-2 rounded bg-[var(--muted)]/50">
        <div class="text-[10px] uppercase font-semibold text-[var(--muted-foreground)]">Paletas Oficiais</div>
        <div class="text-xs font-bold text-amber-400 mt-0.5">Aço, Ouro & Lúmen</div>
        <div class="text-[10px] text-[var(--muted-foreground)]">Contraste AMOLED</div>
      </div>
      <div class="p-2 rounded bg-[var(--muted)]/50">
        <div class="text-[10px] uppercase font-semibold text-[var(--muted-foreground)]">Iluminação & Sel-Out</div>
        <div class="text-xs font-bold text-sky-400 mt-0.5">Top-Left 45°</div>
        <div class="text-[10px] text-[var(--muted-foreground)]">Alpha Binário [0, 255]</div>
      </div>
    </div>
  </div>

  <script>
    function showMedia(mode) {{
      const gif = document.getElementById('view-gif');
      const png = document.getElementById('view-png');
      const btnGif = document.getElementById('btn-gif');
      const btnPng = document.getElementById('btn-png');
      
      if (mode === 'gif') {{
        gif.classList.remove('hidden');
        gif.classList.add('block');
        png.classList.remove('block');
        png.classList.add('hidden');
        btnGif.className = "px-2.5 py-1 text-xs rounded font-medium bg-emerald-600 text-white hover:bg-emerald-500 transition";
        btnPng.className = "px-2.5 py-1 text-xs rounded font-medium bg-[var(--muted)] text-[var(--foreground)] hover:bg-zinc-700 transition";
      }} else {{
        png.classList.remove('hidden');
        png.classList.add('block');
        gif.classList.remove('block');
        gif.classList.add('hidden');
        btnPng.className = "px-2.5 py-1 text-xs rounded font-medium bg-emerald-600 text-white hover:bg-emerald-500 transition";
        btnGif.className = "px-2.5 py-1 text-xs rounded font-medium bg-[var(--muted)] text-[var(--foreground)] hover:bg-zinc-700 transition";
      }}
    }}
  </script>
</body>
</html>
"""

with open(OUT_HTML, "w", encoding="utf-8") as f:
    f.write(html_content)

print("HTML salvo em:", OUT_HTML)
