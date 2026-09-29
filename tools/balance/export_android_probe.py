#!/usr/bin/env python3
"""Export an isolated Android debug build without changing the normal app/save.

Temporarily changes only package identity in export_presets.cfg, restores the
exact original bytes in finally, and writes an ignored APK under build/.
"""

from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[2]
PRESET = ROOT / "export_presets.cfg"
GODOT = ROOT / "Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe"
OUTPUT = ROOT / "build/pocket_hero_balance_probe.apk"
OLD = b'package/unique_name="com.playertwo.pockethero"'
NEW = b'package/unique_name="com.playertwo.pockethero.balanceprobe"'

original = PRESET.read_bytes()
if original.count(OLD) != 1 or not GODOT.is_file():
    raise SystemExit("Preset or Godot executable not in expected state")
try:
    PRESET.write_bytes(original.replace(OLD, NEW))
    result = subprocess.run([str(GODOT), "--headless", "--path", str(ROOT),
                             "--export-debug", "Android", str(OUTPUT)],
                            cwd=ROOT, stdout=subprocess.PIPE,
                            stderr=subprocess.STDOUT, text=True, errors="replace")
    print("\n".join(result.stdout.splitlines()[-6:]))
    print(f"exit={result.returncode} apk_exists={OUTPUT.is_file()}")
    raise SystemExit(result.returncode)
finally:
    PRESET.write_bytes(original)
