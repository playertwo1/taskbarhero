import os
import sys
from PIL import Image, ImageDraw

PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
sys.path.insert(0, PROJECT_ROOT)

ICONS_DIR = os.path.join(PROJECT_ROOT, "assets", "sprites", "skills", "icons")
ARTIFACTS_DIR = r"C:\Users\notefael\.gemini\antigravity\brain\a967aa1b-4428-4099-947a-ad6f69740286"

from scripts.art.build_all_skill_icons import SKILLS

# Grid: 3 rows of 5 icons (Bastião, Flecha, Íris)
cols = 5
rows = 3
scale = 3
cell_w = 32 * scale
cell_h = 32 * scale
padding = 16

total_w = cols * cell_w + (cols + 1) * padding
total_h = rows * cell_h + (rows + 1) * padding

sheet = Image.new("RGBA", (total_w, total_h), (24, 32, 41, 255)) # Dark slate #182029
draw = ImageDraw.Draw(sheet)

for idx, sk in enumerate(SKILLS):
    r = idx // cols
    c = idx % cols
    x = padding + c * (cell_w + padding)
    y = padding + r * (cell_h + padding)
    
    # Slot frame
    draw.rectangle([(x - 2, y - 2), (x + cell_w + 1, y + cell_h + 1)], fill=(47, 49, 64, 255), outline=(98, 124, 128, 255))
    
    # Load icon
    p = os.path.join(ICONS_DIR, f"{sk['id']}.png")
    im = Image.open(p).convert("RGBA")
    im_scaled = im.resize((cell_w, cell_h), Image.Resampling.NEAREST)
    sheet.paste(im_scaled, (x, y), im_scaled)

out_preview = os.path.join(PROJECT_ROOT, "docs", "art", "previews", "skill_icons_32x32_contact_sheet.png")
sheet.save(out_preview)
art_preview = os.path.join(ARTIFACTS_DIR, "skill_icons_32x32_contact_sheet.png")
sheet.save(art_preview)
print("Skill icons contact sheet created successfully!")
