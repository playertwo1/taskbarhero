extends Node

## StateExporter: Produz snapshots estruturados em JSON do estado interno do jogo
## para comparacao com a visao de tela do Argos e reproducao deterministica de bugs.

const SNAPSHOTS_DIR := "user://snapshots/"

## Snapshot da expedição do slice (SliceSession/ExpeditionRun). context: build, nível, seed, tentativa.
func capture_slice_snapshot(run: ExpeditionRun, context: Dictionary = {}) -> Dictionary:
	if run == null:
		return {}
	return {
		"kind": "slice_expedition",
		"timestamp": Time.get_datetime_string_from_system(true),
		"context": context.duplicate(true),
		"run": run.snapshot(),
	}

## Estado corrente em caminho fixo, para leitura externa (ex.: adb run-as no Android). Só em DevMode.
const SLICE_STATE_PATH := "user://argos/slice_state.json"

func write_slice_state(snapshot: Dictionary) -> String:
	if not DevMode.is_enabled or snapshot.is_empty():
		return ""
	DirAccess.make_dir_recursive_absolute("user://argos")
	var file := FileAccess.open(SLICE_STATE_PATH, FileAccess.WRITE)
	if file == null:
		return ""
	file.store_string(JSON.stringify(snapshot, "	"))
	return SLICE_STATE_PATH

func save_snapshot_to_file(snapshot: Dictionary, filename_prefix: String = "snapshot") -> String:
	DirAccess.make_dir_absolute(SNAPSHOTS_DIR)
	var timestamp_str := Time.get_datetime_string_from_system().replace(":", "-")
	var path := "%s%s_%s.json" % [SNAPSHOTS_DIR, filename_prefix, timestamp_str]
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file != null:
		file.store_string(JSON.stringify(snapshot, "\t"))
		return path
	return ""
