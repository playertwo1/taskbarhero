extends Node

var success := true
const PATH := "user://test_loadout_builds.json"

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] %s" % label)
	else:
		print("FALHA: %s" % label)
		success = false

func _cleanup() -> void:
	for p in [PATH, PATH + ".tmp"]:
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(p))

func _ready() -> void:
	print("--- TESTE LOADOUT COM BUILD LIVRE (UI_S04) ---")
	_cleanup()
	_test_options_match_data()
	_test_every_combination_builds_a_run()
	await _test_screen()
	_cleanup()
	print("=======================================================")
	print("[%s] TESTE LOADOUT COM BUILD LIVRE" % ("PASS" if success else "FAIL"))
	get_tree().quit(0 if success else 1)

func _test_options_match_data() -> void:
	print("\n>>> 1. OPÇÕES VÊM DOS DADOS DE HERÓI")
	var rows := SliceStats.load_rows("res://data/heroes/heroes.json", "slice")
	var by_id := {}
	for row in rows:
		by_id[row["id"]] = row
	var total := 1
	for hero_id in SliceSession.BUILD_OPTIONS:
		var ok := by_id.has(hero_id)
		for key in SliceSession.BUILD_OPTIONS[hero_id]:
			var base := String(key).trim_suffix("_tele")
			ok = ok and by_id[hero_id]["builds"].has(base) and SliceSession.BUILD_LABELS.has(key)
		_expect("builds de %s existem nos dados e têm rótulo" % hero_id, ok)
		total *= SliceSession.BUILD_OPTIONS[hero_id].size()
	_expect("18 combinações (3 × 2 × 3)", total == 18)
	var covered := true
	for preset in SliceSession.BUILD_PRESETS:
		for hero_id in preset["heroes"]:
			covered = covered and SliceSession.BUILD_OPTIONS[hero_id].has(preset["heroes"][hero_id])
	_expect("os 4 presets são combinações escolhíveis", covered)

func _test_every_combination_builds_a_run() -> void:
	print("\n>>> 2. TODA COMBINAÇÃO CRIA UMA EXPEDIÇÃO")
	var made := 0
	for b1 in SliceSession.BUILD_OPTIONS["hero_001"]:
		for b2 in SliceSession.BUILD_OPTIONS["hero_002"]:
			for b3 in SliceSession.BUILD_OPTIONS["hero_003"]:
				var run := SliceSession.create_run({"hero_001": b1, "hero_002": b2, "hero_003": b3}, 5, 7)
				if run != null and run.state != "lost":
					made += 1
	_expect("as 18 combinações criam uma run válida", made == 18)

func _test_screen() -> void:
	print("\n>>> 3. TELA")
	var screen: SliceCampaignScreen = load("res://scenes/slice/SliceCampaign.tscn").instantiate()
	screen.save_path = PATH
	add_child(screen)
	await get_tree().process_frame
	_expect("começa no primeiro preset", screen.selected_build == SliceSession.BUILD_PRESETS[0]["heroes"])
	_expect("escolher build de um herói não muda os outros", screen.set_build("hero_001", "guardiao") and screen.selected_build["hero_001"] == "guardiao" and screen.selected_build["hero_002"] == SliceSession.BUILD_PRESETS[0]["heroes"]["hero_002"])
	_expect("recusa build de outro herói", not screen.set_build("hero_002", "arcano") and screen.selected_build["hero_002"] != "arcano")
	_expect("recusa herói desconhecido", not screen.set_build("hero_999", "guardiao"))
	_expect("seletor acompanha a escolha", screen._build_pickers["hero_001"].selected == 0)
	screen.apply_preset(1)
	_expect("preset preenche os três heróis", screen.selected_build == SliceSession.BUILD_PRESETS[1]["heroes"] and screen._build_pickers["hero_003"].selected == SliceSession.BUILD_OPTIONS["hero_003"].find("controle"))
	screen.set_build("hero_002", "critico")
	screen.start_selected()
	_expect("a run usa a build escolhida e trava o inventário", screen.mode == "run" and screen.campaign.inventory.locked and screen.run != null)
	screen.queue_free()
