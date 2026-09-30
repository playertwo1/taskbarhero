extends RefCounted
class_name SliceSession

## Monta uma expedição do slice a partir dos dados de /data (rota, heróis, inimigos, skills,
## passivas e itens). Usado pela tela de teste e pelo DebugBridge; a lógica fica no ExpeditionRun.
## Build: herói → chave de build; o sufixo "_tele" guarda o Contra-Golpe para o golpe telegrafado
## (gatilho ajustável no Hub, SKILL_SYSTEM.md).

const ROUTE_PATH := "res://data/expedition/route_c1.json"
const TELEGRAPH_OVERRIDE := {"skill_bas_007": {"type": "telegraph_on_self"}}

## Builds prontas para a tela e o teste (herói → chave de build; "_tele" liga o gatilho do golpe telegrafado).
const BUILD_PRESETS := [
	{"name": "Ofensivo", "heroes": {"hero_001": "retaliacao", "hero_002": "marca", "hero_003": "arcano"}},
	{"name": "Controle", "heroes": {"hero_001": "retaliacao_tele", "hero_002": "marca", "hero_003": "controle"}},
	{"name": "Guardião", "heroes": {"hero_001": "guardiao", "hero_002": "critico", "hero_003": "controle"}},
	{"name": "Cura", "heroes": {"hero_001": "retaliacao", "hero_002": "critico", "hero_003": "lumen"}},
]

## Builds que o jogador pode escolher por herói (UI_S04): combinações de 3 heróis (o total é o produto das opções).
const BUILD_OPTIONS := {
	"hero_001": ["guardiao", "retaliacao", "retaliacao_tele", "controle"],
	"hero_002": ["critico", "marca", "velocidade"],
	"hero_003": ["arcano", "controle", "lumen"],
}
const BUILD_LABELS := {
	"guardiao": "Guardião", "retaliacao": "Retaliação", "retaliacao_tele": "Retaliação (golpe telegrafado)",
	"critico": "Crítico", "marca": "Marca", "velocidade": "Velocidade", "arcano": "Arcano", "controle": "Controle", "lumen": "Lúmen",
}

static var _cache: Dictionary = {}

static func data() -> Dictionary:
	if _cache.is_empty():
		var file := FileAccess.open(ROUTE_PATH, FileAccess.READ)
		_cache = {
			"route": JSON.parse_string(file.get_as_text()) if file != null else {},
			"heroes": SliceStats.load_rows("res://data/heroes/heroes.json", "slice"),
			"enemies": SliceStats.load_rows("res://data/enemies/enemies.json", "slice"),
			"skills": SliceStats.load_rows("res://data/skills/skills_slice.json", "slice"),
			"passives": SliceStats.load_rows("res://data/skills/passives_slice.json", "slice"),
			"items": SliceStats.load_rows("res://data/items/items.json", "slice"),
		}
	return _cache

## Opções do ExpeditionRun.create; extra sobrescreve (equipment, skill_ranks, crits...).
static func options(build: Dictionary, level: int, seed_value: int, extra: Dictionary = {}) -> Dictionary:
	var d := data()
	var builds := {}
	var overrides := {}
	for hid in build:
		builds[hid] = String(build[hid]).trim_suffix("_tele")
		if String(build[hid]).ends_with("_tele"):
			overrides.merge(TELEGRAPH_OVERRIDE)
	var opts := {"seed": seed_value, "crits": true, "party_level": level, "skills": d["skills"], "builds": builds,
		"trigger_overrides": overrides, "passives": d["passives"], "items": d["items"], "passive_tree": true}
	opts.merge(extra, true)
	return opts

static func create_run(build: Dictionary, level: int, seed_value: int, extra: Dictionary = {}) -> ExpeditionRun:
	var d := data()
	return ExpeditionRun.create(d["route"], d["heroes"], d["enemies"], options(build, level, seed_value, extra))
