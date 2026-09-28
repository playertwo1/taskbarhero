import os
import sys
import json

PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
sys.path.insert(0, PROJECT_ROOT)

from scripts.art.build_all_skill_icons import SKILLS
SKILL_CONTRACTS_DIR = os.path.join(PROJECT_ROOT, "docs", "art", "contracts", "skill_icons")
os.makedirs(SKILL_CONTRACTS_DIR, exist_ok=True)

for sk in SKILLS:
    subsets_sorted = sorted(sk['subsets'])
    contract_name = f"skill_icon_{'_'.join(subsets_sorted)}.yaml"
    contract_path = os.path.join(SKILL_CONTRACTS_DIR, contract_name)
    
    contract_data = {
        "contract_version": "1.0.0",
        "category": "skill_icon",
        "canvas": {
            "width": 32,
            "height": 32,
            "baseline_y": 32,
            "pivot": [16, 32]
        },
        "style": "dark_fantasy_pixel_art",
        "palette": {
            "master": "TY_HIGH_FANTASY_40",
            "subsets": subsets_sorted,
            "max_colors": 14
        },
        "export": {
            "format": "png",
            "color_depth": "rgba_32",
            "transparent_background": True,
            "icon_only": True
        },
        "acceptance_criteria": {
            "technical": [
                "canvas_size_exact: 32x32",
                "binary_alpha: true",
                "only_declared_TY40_subsets: true",
                "max_colors: 14"
            ]
        }
    }
    
    with open(contract_path, 'w', encoding='utf-8') as f:
        json.dump(contract_data, f, indent=2)
        
    # Update manifest
    manifest_path = os.path.join(PROJECT_ROOT, "assets", "sprites", "skills", "manifests", f"{sk['id']}.manifest.yaml")
    if os.path.exists(manifest_path):
        with open(manifest_path, 'r', encoding='utf-8') as mf:
            mdata = json.load(mf)
        mdata['contract'] = f"docs/art/contracts/skill_icons/{contract_name}"
        mdata['palette']['subsets'] = subsets_sorted
        with open(manifest_path, 'w', encoding='utf-8') as mf:
            json.dump(mdata, mf, indent=2)

print("Skill contracts created and manifests updated successfully!")
