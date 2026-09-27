extends Node

const SAVE_PATH := "user://pocket_hero_save.json"

signal game_saved()
signal game_loaded(state: Dictionary)

func save_game(state: Dictionary) -> bool:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_warning("SaveManager: Não foi possível abrir o arquivo de save para escrita: %s" % error_string(FileAccess.get_open_error()))
		return false
	var json_str := JSON.stringify(state, "\t")
	file.store_string(json_str)
	game_saved.emit()
	return true

func load_game() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return {}
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_warning("SaveManager: Não foi possível abrir o arquivo de save para leitura: %s" % error_string(FileAccess.get_open_error()))
		return {}
	var parsed = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		game_loaded.emit(parsed)
		return parsed
	return {}

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func delete_save() -> bool:
	if FileAccess.file_exists(SAVE_PATH):
		var err := DirAccess.remove_absolute(SAVE_PATH)
		return err == OK
	return true
