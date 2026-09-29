"""Gera a vista legível dos textos de eventos do slice a partir dos dados.

Fonte única: data/expedition/event_texts_c1.json (textos) e data/expedition/events_c1.json (nomes).
Saída derivada: docs/04_content/chapters/chapter_01/EVENT_TEXTS.md. Não edite a saída à mão.

Uso: python tools/content/export_event_texts.py
"""
import json
import pathlib

ROOT = pathlib.Path(__file__).resolve().parents[2]
TEXTS = ROOT / "data" / "expedition" / "event_texts_c1.json"
EVENTS = ROOT / "data" / "expedition" / "events_c1.json"
OUT = ROOT / "docs" / "04_content" / "chapters" / "chapter_01" / "EVENT_TEXTS.md"


def main() -> None:
    texts = json.loads(TEXTS.read_text(encoding="utf-8"))
    events = json.loads(EVENTS.read_text(encoding="utf-8"))["events"]
    lines = [
        "---",
        "id: EVENT_TEXTS_C1",
        "status: DESIGN",
        "certainty: HIPOTESE",
        "derived_from: data/expedition/event_texts_c1.json",
        "---",
        "",
        "# Textos dos eventos de expedição — Capítulo 1 (vista derivada)",
        "",
        "**Não edite este arquivo.** Ele é gerado por `python tools/content/export_event_texts.py` a partir de "
        "[`event_texts_c1.json`](../../../../data/expedition/event_texts_c1.json), que é a fonte dos textos. "
        "Mecânica, condições e valores dos eventos ficam em [SLICE_1B_RUN_SPEC](../../../03_systems/SLICE_1B_RUN_SPEC.md) "
        "e em [`events_c1.json`](../../../../data/expedition/events_c1.json).",
        "",
        "**Status:** `DESIGN`; textos escritos em 2026-09-29 a partir da [lore canônica](../../../01_world/loreparte1.md) e da "
        "[Bíblia de Lore](../../../01_world/LORE_BIBLE.md), aguardando revisão de Rafael.",
        "",
        "## Regras de escrita",
        "",
    ]
    lines += [f"- {rule}" for rule in texts["rules"]]
    lines.append("")
    for event in events:
        block = texts["events"].get(event["id"])
        if block is None:
            continue
        lines += [f"## {event['name']} (`{event['id']}`, {event['kind']})", "", f"**Ao aparecer:** {block['intro']}", ""]
        for choice in event["choices"]:
            if choice.get("per_hero"):
                ids = [k for k in block["choices"] if k.startswith(choice["id"] + "_")]
                for cid in ids:
                    lines.append(f"- **{choice['label'].replace('{hero}', cid.split('_', 1)[1])}:** {block['choices'][cid]}")
            else:
                lines.append(f"- **{choice['label']}:** {block['choices'].get(choice['id'], '(sem texto)')}")
                for outcome in choice.get("outcomes", []):
                    lines.append(f"  - *Resultado `{outcome['id']}`:* {block['outcomes'].get(outcome['id'], '(sem texto)')}")
        lines.append("")
    lines += ["## Textos de lore reveladas", ""]
    lines += [f"- `{key}`: {value}" for key, value in texts["lore"].items()]
    lines.append("")
    OUT.write_text("\n".join(lines), encoding="utf-8", newline="\n")
    print(f"ok: {OUT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
