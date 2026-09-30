extends RefCounted
class_name SliceSave

## Save mínimo do slice (SLICE-1B): JSON versionado. Leitura nunca apaga nem sobrescreve.
## Versão desconhecida ou JSON corrompido devolvem ok=false; quem chama bloqueia a gravação.

const VERSION := 1

static func default_data() -> Dictionary:
	return {"version": VERSION, "inventory": {}, "party": {"level": 1, "xp": 0}, "boss_cleared": false, "flags": {}, "lore": [], "fragments": 0, "tree_nodes": [], "milestones": []}

static func read(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {"ok": true, "error": "missing", "data": default_data()}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {"ok": false, "error": "corrupt", "data": {}}
	var parsed = JSON.parse_string(file.get_as_text())
	if not (parsed is Dictionary):
		return {"ok": false, "error": "corrupt", "data": {}}
	if int(parsed.get("version", -1)) != VERSION:
		return {"ok": false, "error": "version", "data": {}}
	var data := default_data()
	data.merge(parsed, true)
	data["party"] = {"level": int(data["party"]["level"]), "xp": int(data["party"]["xp"])}
	data["fragments"] = int(data["fragments"])
	data["tree_nodes"] = Array(data["tree_nodes"])
	data["milestones"] = Array(data["milestones"])
	return {"ok": true, "error": "", "data": data}

## Escreve em arquivo temporário e renomeia, para não deixar o save pela metade.
static func write(path: String, data: Dictionary) -> bool:
	var tmp := path + ".tmp"
	var file := FileAccess.open(tmp, FileAccess.WRITE)
	if file == null:
		return false
	file.store_string(JSON.stringify(data, "\t"))
	file.close()
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
	return DirAccess.rename_absolute(ProjectSettings.globalize_path(tmp), ProjectSettings.globalize_path(path)) == OK

## Soma XP à party e devolve quantos níveis subiu (teto em profiles["xp"]["max_level"]).
static func add_xp(data: Dictionary, amount: int, profiles: Dictionary) -> int:
	var party: Dictionary = data["party"]
	var max_level := int(profiles["xp"]["max_level"])
	var gained := 0
	party["xp"] = int(party["xp"]) + amount
	while int(party["level"]) < max_level:
		var need := ExpeditionRun.xp_to_next(int(party["level"]), profiles)
		if int(party["xp"]) < need:
			break
		party["xp"] = int(party["xp"]) - need
		party["level"] = int(party["level"]) + 1
		gained += 1
	if int(party["level"]) >= max_level:
		party["xp"] = 0
	return gained
