extends Node

var success := true
const PATH := "user://test_slice_save.json"

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] %s" % label)
	else:
		print("FALHA: %s" % label)
		success = false

func _ready() -> void:
	print("--- TESTE SLICE SAVE (SLICE-1B) ---")
	_cleanup()
	_test_missing_and_roundtrip()
	_test_unknown_version_preserved()
	_test_corrupt_preserved()
	_test_xp()
	_cleanup()
	print("=======================================================")
	print("[%s] TESTE SLICE SAVE" % ("PASS" if success else "FAIL"))
	get_tree().quit(0 if success else 1)

func _cleanup() -> void:
	for p in [PATH, PATH + ".tmp"]:
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(p))

func _test_missing_and_roundtrip() -> void:
	print("\n>>> 1. AUSENTE E IDA E VOLTA")
	var res := SliceSave.read(PATH)
	_expect("arquivo ausente vira save novo", res["ok"] and res["data"]["version"] == SliceSave.VERSION and res["data"]["party"]["level"] == 1)
	var data := SliceSave.default_data()
	data["boss_cleared"] = true
	data["flags"] = {"observador_visto": true}
	data["party"] = {"level": 7, "xp": 42}
	_expect("write devolve true", SliceSave.write(PATH, data))
	var back := SliceSave.read(PATH)
	_expect("ida e volta preserva os campos", back["ok"] and back["data"]["boss_cleared"] and back["data"]["flags"]["observador_visto"] and int(back["data"]["party"]["level"]) == 7 and int(back["data"]["party"]["xp"]) == 42)
	_expect("não sobra arquivo temporário", not FileAccess.file_exists(PATH + ".tmp"))

func _test_unknown_version_preserved() -> void:
	print("\n>>> 2. VERSÃO DESCONHECIDA")
	var file := FileAccess.open(PATH, FileAccess.WRITE)
	file.store_string('{"version": 999, "party": {"level": 50, "xp": 1}}')
	file.close()
	var res := SliceSave.read(PATH)
	_expect("versão desconhecida é rejeitada", not res["ok"] and res["error"] == "version")
	var check := FileAccess.open(PATH, FileAccess.READ)
	_expect("o arquivo original continua intacto", check.get_as_text().contains("999"))

func _test_corrupt_preserved() -> void:
	print("\n>>> 3. JSON CORROMPIDO")
	var file := FileAccess.open(PATH, FileAccess.WRITE)
	file.store_string("{isto não é json")
	file.close()
	var res := SliceSave.read(PATH)
	_expect("corrompido é rejeitado", not res["ok"] and res["error"] == "corrupt")
	var check := FileAccess.open(PATH, FileAccess.READ)
	_expect("o arquivo corrompido continua intacto", check.get_as_text() == "{isto não é json")

func _test_xp() -> void:
	print("\n>>> 4. XP E NÍVEL")
	var profiles := SliceStats.load_profiles()
	var data := SliceSave.default_data()
	var need := ExpeditionRun.xp_to_next(1, profiles)
	_expect("XP abaixo do necessário não sobe de nível", SliceSave.add_xp(data, need - 1, profiles) == 0 and data["party"]["level"] == 1)
	_expect("cruzar o limite sobe 1 nível e guarda o resto", SliceSave.add_xp(data, 1, profiles) == 1 and data["party"]["level"] == 2 and data["party"]["xp"] == 0)
	var capped := profiles.duplicate(true)
	capped["xp"]["max_level"] = 3
	var big := SliceSave.default_data()
	_expect("XP grande sobe até o teto e para", SliceSave.add_xp(big, 1000000, capped) == 2 and big["party"]["level"] == 3 and big["party"]["xp"] == 0)
