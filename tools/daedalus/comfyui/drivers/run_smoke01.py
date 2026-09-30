"""COMFY-SMOKE-01: Slime de Lumen. Conceito (ComfyUI) -> RGBA -> 48x48 nearest -> paleta lumen (<=20 cores) -> PNG."""
import json, os, sys, hashlib
from PIL import Image
sys.path.append(os.path.dirname(__file__))
from comfy_client import ComfyClient

HERE = os.path.dirname(__file__)
WF = os.path.join(HERE, "..", "workflows", "slime_smoke01_api.json")
OUT = os.path.join(HERE, "..", "..", "..", "..", "build", "smoke01")
LUMEN = ["#000000", "#182029", "#314646", "#425a58", "#627c80", "#81b5a2", "#bdd2de", "#e6dac5"]
SIZE, MAX_COLORS = 48, 20

def hexrgb(h): return tuple(int(h[i:i+2], 16) for i in (1, 3, 5))

def main():
    os.makedirs(OUT, exist_ok=True)
    c = ComfyClient()
    if not c.check_health(): sys.exit("ComfyUI offline")
    wf = json.load(open(WF, encoding="utf-8"))
    pid = c.queue_prompt(wf, client_id="daedalus_smoke01")["prompt_id"]
    hist = c.wait_for_completion(pid, timeout_sec=1800, poll_interval=5.0)
    outs = hist["outputs"]
    for node, name in (("8", "concept.png"), ("10", "rgba_full.png")):
        im = outs[node]["images"][0]
        c.download_image(im["filename"], subfolder=im.get("subfolder", ""), dest_path=os.path.join(OUT, name))
    rgba = Image.open(os.path.join(OUT, "rgba_full.png")).convert("RGBA")
    box = rgba.getchannel("A").point(lambda a: 255 if a > 127 else 0).getbbox()
    if not box: sys.exit("FAIL: alpha vazio")
    crop = rgba.crop(box); s = max(crop.size)
    sq = Image.new("RGBA", (s, s), (0, 0, 0, 0)); sq.paste(crop, ((s - crop.width) // 2, s - crop.height))
    small = sq.resize((SIZE, SIZE), Image.NEAREST)
    pal = [hexrgb(h) for h in LUMEN]
    px = small.load()
    for y in range(SIZE):
        for x in range(SIZE):
            r, g, b, a = px[x, y]
            if a < 128: px[x, y] = (0, 0, 0, 0); continue
            q = min(pal, key=lambda p: (p[0]-r)**2 + (p[1]-g)**2 + (p[2]-b)**2)
            px[x, y] = q + (255,)
    dest = os.path.join(OUT, "enemy_lumen_slime_smoke01_48.png"); small.save(dest)
    cols = {p[:3] for p in small.getdata() if p[3]}
    alphas = {p[3] for p in small.getdata()}
    rec = {"prompt_id": pid, "seed": wf["6"]["inputs"]["seed"], "workflow": "workflows/slime_smoke01_api.json",
           "workflow_sha256": hashlib.sha256(open(WF, "rb").read()).hexdigest(), "size": small.size,
           "colors": len(cols), "alpha_values": sorted(alphas), "png_sha256": hashlib.sha256(open(dest, "rb").read()).hexdigest()}
    json.dump(rec, open(os.path.join(OUT, "smoke01_result.json"), "w"), indent=2)
    ok = small.size == (SIZE, SIZE) and len(cols) <= MAX_COLORS and alphas <= {0, 255}
    print(rec, "TECH:", "PASS" if ok else "FAIL")

if __name__ == "__main__": main()
