"""
Showcase Completo do Roster e Cenario do Bosque de Lumen (FASE R11 - Fechamento do Gate R11):
Renderiza toda a linha de producao artistica:
- Trio de Herois: Flecha (Back), Iris (Mid), Bastiao (Front)
- Inimigos Comuns: Geleia de Lumen, Gremlin de Folha, Javali de Musgo, Espirito de Raiz
- Elite: Lobo Alfa de Lumen
- Chefe Supremo: Guardiao-Cervo de Pedra
- Cenario em 5 camadas (fundo distante, arvores intermediarias, particulas, solo, primeiro plano)
"""

import os
import base64
from PIL import Image, ImageDraw

PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
ARTIFACT_DIR = r"C:\Users\notefael\.gemini\antigravity\brain\a967aa1b-4428-4099-947a-ad6f69740286"

HERO_BASTIAO = os.path.join(PROJECT_ROOT, "assets", "sprites", "heroes", "bastiao", "hero_bastiao_sheet.png")
HERO_FLECHA  = os.path.join(PROJECT_ROOT, "assets", "sprites", "heroes", "flecha", "hero_flecha_sheet.png")
HERO_IRIS    = os.path.join(PROJECT_ROOT, "assets", "sprites", "heroes", "iris", "hero_iris_sheet.png")

MOB_SLIME    = os.path.join(PROJECT_ROOT, "assets", "sprites", "enemies", "geleia_de_lumen", "enemy_geleia_lumen_sheet.png")
MOB_GREMLIN  = os.path.join(PROJECT_ROOT, "assets", "sprites", "enemies", "gremlin_de_folha", "mob_gremlin_folha_sheet.png")
MOB_JAVALI   = os.path.join(PROJECT_ROOT, "assets", "sprites", "enemies", "javali_de_musgo", "mob_javali_musgo_sheet.png")
MOB_ESPIRITO = os.path.join(PROJECT_ROOT, "assets", "sprites", "enemies", "espirito_de_raiz", "mob_espirito_raiz_sheet.png")
MOB_LOBO     = os.path.join(PROJECT_ROOT, "assets", "sprites", "enemies", "lobo_alfa_de_lumen", "mob_lobo_alfa_sheet.png")
BOSS_CERVO   = os.path.join(PROJECT_ROOT, "assets", "sprites", "bosses", "guardiao_cervo", "boss_guardiao_cervo_sheet.png")

ENV_BG       = os.path.join(PROJECT_ROOT, "assets", "sprites", "environment", "bosque_lumen", "bg_distant.png")
ENV_MID      = os.path.join(PROJECT_ROOT, "assets", "sprites", "environment", "bosque_lumen", "mid_trees.png")
ENV_GROUND   = os.path.join(PROJECT_ROOT, "assets", "sprites", "environment", "bosque_lumen", "ground_strip.png")
ENV_FG       = os.path.join(PROJECT_ROOT, "assets", "sprites", "environment", "bosque_lumen", "fg_elements.png")

W = 1000
H = 340
GROUND_Y = 270 # Baseline dos pés em escala 2x

def extract_idle_frame(sheet_path, frame_w, frame_h, frame_idx=0):
    sheet = Image.open(sheet_path).convert("RGBA")
    return sheet.crop((frame_idx * frame_w, 0, (frame_idx + 1) * frame_w, frame_h))

def render_showcase():
    canvas = Image.new("RGBA", (W, H), (6, 8, 7, 255))
    
    # 1. Repetir e desenhar camadas cenicas (2x)
    bg_img = Image.open(ENV_BG).convert("RGBA").resize((216 * 2, 110 * 2), Image.NEAREST)
    mid_img = Image.open(ENV_MID).convert("RGBA").resize((216 * 2, 110 * 2), Image.NEAREST)
    ground_img = Image.open(ENV_GROUND).convert("RGBA").resize((216 * 2, 42 * 2), Image.NEAREST)
    fg_img = Image.open(ENV_FG).convert("RGBA").resize((216 * 2, 24 * 2), Image.NEAREST)

    for x in range(0, W, 432):
        canvas.paste(bg_img, (x, 50), bg_img)
        canvas.paste(mid_img, (x, 50), mid_img)
        canvas.paste(ground_img, (x, GROUND_Y - 4), ground_img)

    # 2. Orbes de lúmen cintilante
    d = ImageDraw.Draw(canvas, "RGBA")
    for px, py, r in [(120, 110, 4), (280, 80, 5), (490, 130, 3), (670, 95, 6), (880, 120, 5)]:
        d.ellipse([px - r, py - r, px + r, py + r], fill=(86, 211, 100, 120))
        d.ellipse([px - r//2, py - r//2, px + r//2, py + r//2], fill=(175, 245, 180, 220))

    # 3. Entidades alinhadas na Baseline Y=GROUND_Y (escala uniforme 2.0x, Nearest)
    # HEROES: Flecha (Back, X=60), Íris (Mid, X=130), Bastião (Front, X=200)
    # Todos 48x48, baseline interna Y=44 -> topo = GROUND_Y - 44*2 = GROUND_Y - 88
    flecha_f = extract_idle_frame(HERO_FLECHA, 48, 48, 0).resize((96, 96), Image.NEAREST)
    iris_f   = extract_idle_frame(HERO_IRIS, 48, 48, 0).resize((96, 96), Image.NEAREST)
    bast_f   = extract_idle_frame(BASTIAO_HERO if 'BASTIAO_HERO' in globals() else HERO_BASTIAO, 48, 48, 0).resize((96, 96), Image.NEAREST)

    canvas.paste(flecha_f, (40, GROUND_Y - 88), flecha_f)
    canvas.paste(iris_f, (110, GROUND_Y - 88), iris_f)
    canvas.paste(bast_f, (180, GROUND_Y - 88), bast_f)

    # ENEMIES:
    # Geleia de Lúmen: 64x64, baseline Y=60 -> topo = GROUND_Y - 60*2
    slime_f   = extract_idle_frame(MOB_SLIME, 64, 64, 0).resize((128, 128), Image.NEAREST)
    canvas.paste(slime_f, (340, GROUND_Y - 120), slime_f)

    # Gremlin: 32x32, baseline Y=29 -> topo = GROUND_Y - 58
    gremlin_f = extract_idle_frame(MOB_GREMLIN, 32, 32, 0).resize((64, 64), Image.NEAREST)
    canvas.paste(gremlin_f, (430, GROUND_Y - 58), gremlin_f)

    # Javali: 48x48, baseline Y=44 -> topo = GROUND_Y - 88
    javali_f  = extract_idle_frame(MOB_JAVALI, 48, 48, 0).resize((96, 96), Image.NEAREST)
    canvas.paste(javali_f, (520, GROUND_Y - 88), javali_f)

    # Espírito de Raiz: 48x48, baseline Y=44 -> topo = GROUND_Y - 88
    espirito_f= extract_idle_frame(MOB_ESPIRITO, 48, 48, 0).resize((96, 96), Image.NEAREST)
    canvas.paste(espirito_f, (640, GROUND_Y - 88), espirito_f)

    # Lobo Alfa (Elite): 48x48, baseline Y=44 -> topo = GROUND_Y - 88
    lobo_f    = extract_idle_frame(MOB_LOBO, 48, 48, 0).resize((96, 96), Image.NEAREST)
    canvas.paste(lobo_f, (740, GROUND_Y - 88), lobo_f)

    # Guardião-Cervo (Boss): 64x64, baseline Y=60 -> topo = GROUND_Y - 60*2 = GROUND_Y - 120
    boss_f    = extract_idle_frame(BOSS_CERVO, 64, 64, 0).resize((128, 128), Image.NEAREST)
    canvas.paste(boss_f, (850, GROUND_Y - 120), boss_f)

    # 4. Elementos de primeiro plano (Foreground) por cima dos pés
    for x in range(0, W, 432):
        canvas.paste(fg_img, (x, H - 48), fg_img)

    # Legenda e rótulos
    d.line([(0, 0), (W, 0)], fill=(23, 35, 28, 255), width=2)
    d.line([(0, H - 1), (W, H - 1)], fill=(23, 35, 28, 255), width=2)

    # Salvar nos diretórios oficiais
    out_docs = os.path.join(PROJECT_ROOT, "docs", "art", "preview_bosque_lumen_complete.png")
    canvas.save(out_docs)
    print(f"[OK] Showcase oficial salvo em: {out_docs}")

    out_artifact = os.path.join(ARTIFACT_DIR, "preview_bosque_lumen_complete.png")
    canvas.save(out_artifact)
    print(f"[OK] Showcase de artefato salvo em: {out_artifact}")

    # Gerar HTML interativo
    with open(out_artifact, "rb") as f:
        b64 = base64.b64encode(f.read()).decode("ascii")

    html_content = f"""<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<title>Pocket Hero — Bosque de Lúmen Roster Completo (Gate R11)</title>
<style>
  body {{
    background-color: #060807;
    color: #e0f2e9;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    margin: 0;
    padding: 24px;
    display: flex;
    flex-direction: column;
    align-items: center;
  }}
  .card {{
    background: #0d1410;
    border: 1px solid #1a3826;
    border-radius: 12px;
    padding: 24px;
    max-width: 1040px;
    box-shadow: 0 8px 32px rgba(0,0,0,0.8);
  }}
  h1 {{
    margin-top: 0;
    color: #56d364;
    font-size: 24px;
    display: flex;
    align-items: center;
    gap: 12px;
  }}
  .badge {{
    background: #145932;
    color: #a8ffcc;
    font-size: 12px;
    padding: 4px 8px;
    border-radius: 6px;
    font-weight: bold;
    text-transform: uppercase;
  }}
  .preview-box {{
    background: #000;
    border: 2px solid #234d35;
    border-radius: 8px;
    overflow: hidden;
    margin: 20px 0;
  }}
  .preview-box img {{
    display: block;
    width: 100%;
    image-rendering: pixelated;
  }}
  .roster-grid {{
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 16px;
    margin-top: 20px;
  }}
  .roster-item {{
    background: #101c15;
    border: 1px solid #1c3d2a;
    border-radius: 8px;
    padding: 12px;
  }}
  .roster-item h3 {{
    margin: 0 0 6px 0;
    font-size: 15px;
    color: #7ee787;
  }}
  .roster-item p {{
    margin: 0;
    font-size: 12px;
    color: #8b9bb4;
    line-height: 1.4;
  }}
  .spec-tag {{
    color: #aff5b4;
    font-weight: bold;
  }}
</style>
</head>
<body>
<div class="card">
  <h1>
    <span>🌲 Bosque de Lúmen — Roster Completo e Cenário</span>
    <span class="badge">Gate R11 Homologado</span>
  </h1>
  <p style="color: #94a3b8; font-size: 14px; margin-bottom: 8px;">
    Todas as 9 entidades do bioma Bosque de Lúmen renderizadas sobre as 5 camadas cênicas AMOLED. Zero mixels, iluminação canônica top-left 45°, alpha estrito e paletas oficiais.
  </p>

  <div class="preview-box">
    <img src="data:image/png;base64,{b64}" alt="Roster Completo Bosque de Lumen" />
  </div>

  <div class="roster-grid">
    <div class="roster-item">
      <h3>🏹 Flecha (Back)</h3>
      <p><span class="spec-tag">48×48 px • Rampa Silvestre</span><br>DPS de longo alcance com arco ágil e capa esmeralda.</p>
    </div>
    <div class="roster-item">
      <h3>✨ Íris (Mid)</h3>
      <p><span class="spec-tag">48×48 px • Rampa Nobre/Lúmen</span><br>Maga conjuradora com cajado e orbe bioluminescente.</p>
    </div>
    <div class="roster-item">
      <h3>🛡️ Bastião (Front)</h3>
      <p><span class="spec-tag">48×48 px • Rampa Ferro/Ouro</span><br>Tanque de vanguarda com escudo torre e espada pesada.</p>
    </div>
    <div class="roster-item">
      <h3>🧪 Geleia de Lúmen</h3>
      <p><span class="spec-tag">32×32 px • Rampa Lúmen</span><br>Primeiro monstro do bioma com núcleo pulsante translúcido.</p>
    </div>
    <div class="roster-item">
      <h3>🍃 Gremlin de Folha</h3>
      <p><span class="spec-tag">32×32 px • Rampa Folha/Terra</span><br>Bípede silvestre com adagas de sílex e olhar astuto.</p>
    </div>
    <div class="roster-item">
      <h3>🐗 Javali de Musgo</h3>
      <p><span class="spec-tag">48×48 px • Rampa Terra/Musgo</span><br>Besta quadrúpede com lombo couraçado e presas marfim.</p>
    </div>
    <div class="roster-item">
      <h3>🌿 Espírito de Raiz</h3>
      <p><span class="spec-tag">48×48 px • Rampa Madeira/Lúmen</span><br>Ent ancestral esguio canalizando magia vegetal pura.</p>
    </div>
    <div class="roster-item">
      <h3>🐺 Lobo Alfa (Elite)</h3>
      <p><span class="spec-tag">48×48 px • Rampa Ardósia/Lúmen</span><br>Predador ápice com runas luminosas no flanco e juba espectral.</p>
    </div>
    <div class="roster-item">
      <h3>🦌 Guardião-Cervo (Boss)</h3>
      <p><span class="spec-tag">64×64 px • Rampa Pedra/Lúmen</span><br>Colosso monolítico de granito com galhadas monumentais.</p>
    </div>
  </div>
</div>
</body>
</html>
"""
    html_path = os.path.join(ARTIFACT_DIR, "bosque_lumen_roster.html")
    with open(html_path, "w", encoding="utf-8") as f:
        f.write(html_content)
    print(f"[OK] Artefato interativo salvo em: {html_path}")

if __name__ == "__main__":
    render_showcase()
