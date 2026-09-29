"""Valida a composição global de balanceamento e suas referências runtime.

Uso: python tools/balance/validate_balance_data.py [--scenario caminho.json]
Não usa dependências externas; os schemas em data/balance/schemas documentam o contrato.
"""
import argparse
import json
import os
import sys


ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
MANIFEST = os.path.join(ROOT, "data", "balance", "combat_profiles.json")
LIFECYCLE = {"CONCEPT", "DESIGN", "APPROVED", "IMPLEMENTING", "IMPLEMENTED", "QA", "PASS", "DEPRECATED"}


def load(path):
    with open(path, encoding="utf-8") as handle:
        return json.load(handle)


def local(resource_path):
    if not isinstance(resource_path, str) or not resource_path.startswith("res://"):
        raise ValueError(f"caminho precisa começar com res://: {resource_path!r}")
    return os.path.join(ROOT, *resource_path[6:].split("/"))


def require(condition, message, errors):
    if not condition:
        errors.append(message)


def ids(rows):
    return {row.get("id") for row in rows if isinstance(row, dict)}


def validate_statuses(value, location, errors):
    if isinstance(value, dict):
        if "status" in value:
            require(value["status"] in LIFECYCLE,
                    f"{location}.status inválido: {value['status']}; use certainty para hipótese/decisão", errors)
        for key, child in value.items():
            validate_statuses(child, f"{location}.{key}", errors)
    elif isinstance(value, list):
        for index, child in enumerate(value):
            validate_statuses(child, f"{location}[{index}]", errors)


def validate(scenario_path=None):
    errors = []
    manifest = load(MANIFEST)
    for key in ("global_profile", "default_chapter", "chapter_profiles"):
        require(key in manifest, f"manifesto sem {key}", errors)
    core_path = local(manifest.get("global_profile", ""))
    require(os.path.isfile(core_path), f"núcleo inexistente: {core_path}", errors)
    if not os.path.isfile(core_path):
        return errors
    core = load(core_path)
    validate_statuses(core, "core", errors)
    for key in ("reference_hero", "archetypes", "ranks", "stat_caps", "threat_profiles", "xp"):
        require(key in core, f"núcleo sem {key}", errors)
    require(core.get("stat_caps", {}).get("damage_taken_multiplier_min", 0) > 0,
            "damage_taken_multiplier_min precisa ser > 0", errors)

    profiles = manifest.get("chapter_profiles", {})
    require(manifest.get("default_chapter") in profiles, "default_chapter não está em chapter_profiles", errors)
    for chapter_key, resource in profiles.items():
        path = local(resource)
        require(os.path.isfile(path), f"perfil inexistente de {chapter_key}: {path}", errors)
        if not os.path.isfile(path):
            continue
        chapter = load(path)
        validate_statuses(chapter, chapter_key, errors)
        require(chapter.get("chapter_id") == chapter_key,
                f"chapter_id {chapter.get('chapter_id')} diverge da chave {chapter_key}", errors)
        require(chapter.get("enemy_damage_scale", 0) > 0, f"{chapter_key}: enemy_damage_scale precisa ser > 0", errors)
        runtime = chapter.get("runtime", {})
        runtime_data = {}
        for key in ("route", "heroes", "enemies", "skills", "passives", "items"):
            try:
                runtime_path = local(runtime.get(key, ""))
            except ValueError as exc:
                errors.append(f"{chapter_key}.{key}: {exc}")
                continue
            require(os.path.isfile(runtime_path), f"{chapter_key}.{key} inexistente: {runtime_path}", errors)
            if os.path.isfile(runtime_path):
                runtime_data[key] = load(runtime_path)
        if not {"route", "heroes", "enemies"}.issubset(runtime_data):
            continue
        route = runtime_data["route"]
        heroes = runtime_data["heroes"]
        enemies = runtime_data["enemies"]
        require(route.get("chapter_id") == chapter_key, f"rota de {chapter_key} declara {route.get('chapter_id')}", errors)
        hero_ids, enemy_ids = ids(heroes), ids(enemies)
        for hero in heroes:
            require(hero.get("threat_profile", "DEFAULT") in core.get("threat_profiles", {}),
                    f"{hero.get('id')}: threat_profile desconhecido", errors)
        party = chapter.get("argos", {}).get("default_party", [])
        require(len(party) == len(set(party)), f"{chapter_key}: party contém IDs repetidos", errors)
        for hero_id in party:
            require(hero_id in hero_ids, f"{chapter_key}: herói da party não existe: {hero_id}", errors)
        node_ids = {node.get("id") for node in route.get("nodes", [])}
        for node in route.get("nodes", []):
            for member in node.get("members", []):
                require(member.get("enemy_id") in enemy_ids,
                        f"{node.get('id')}: inimigo não existe: {member.get('enemy_id')}", errors)
        argos = chapter.get("argos", {})
        for label, node_id in argos.get("segments", {}).items():
            require(node_id in node_ids, f"segmento {label} aponta para nó inexistente: {node_id}", errors)
        require(argos.get("boss_entry_node") in node_ids, "boss_entry_node não existe na rota", errors)

    if scenario_path:
        scenario = load(scenario_path)
        chapter_key = scenario.get("chapter_id", manifest.get("default_chapter"))
        require(chapter_key in profiles, f"cenário usa capítulo desconhecido: {chapter_key}", errors)
        if chapter_key in profiles:
            chapter = load(local(profiles[chapter_key]))
            heroes = load(local(chapter["runtime"]["heroes"]))
            by_id = {row["id"]: row for row in heroes}
            party = scenario.get("party", chapter.get("argos", {}).get("default_party", []))
            for hero_id in party:
                require(hero_id in scenario.get("builds", {}), f"cenário sem builds para {hero_id}", errors)
                for build_id in scenario.get("builds", {}).get(hero_id, []):
                    base_id = build_id[:-5] if build_id.endswith("_tele") else build_id
                    require(base_id in by_id.get(hero_id, {}).get("builds", {}),
                            f"build desconhecida: {hero_id}/{build_id}", errors)
    return errors


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--scenario")
    args = parser.parse_args()
    errors = validate(os.path.abspath(args.scenario) if args.scenario else None)
    if errors:
        for error in errors:
            print(f"ERRO: {error}")
        return 1
    print("Balance data: OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
