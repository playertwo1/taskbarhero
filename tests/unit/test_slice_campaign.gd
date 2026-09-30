extends Node

var success := true
const PATH := "user://test_slice_campaign.json"
const BUILD := {"hero_001": "guardiao", "hero_002": "critico", "hero_003": "controle"}
const LEVEL := 12

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] %s" % label)
	else:
		print("FALHA: %s" % label)
		success = false

func _ready() -> void:
	print("--- TESTE SLICE CAMPAIGN (SLICE-1B) ---")
	_cleanup()
	_test_loot_saved_on_receipt()
	_test_lock_and_equipment()
	_test_echo_award_and_save()
	_test_blocked_save()
	_cleanup()
	print("=======================================================")
	print("[%s] TESTE SLICE CAMPAIGN" % ("PASS" if success else "FAIL"))
	get_tree().quit(0 if success else 1)

func _cleanup() -> void:
	for p in [PATH, PATH + ".tmp"]:
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(p))

## Joga até o fim, ou até o inventário ter `stop_after_items` itens (-1 = sem parada).
func _play(c: SliceCampaign, run: ExpeditionRun, stop_after_items: int = -1) -> void:
	var guard := 0
	while run.state != "won" and run.state != "lost" and guard < 20000:
		guard += 1
		if stop_after_items >= 0 and c.inventory.items.size() >= stop_after_items:
			return
		if run.state == "choice":
			c.choose(run, 0)
		else:
			c.step(run, 0.5)

func _test_loot_saved_on_receipt() -> void:
	print("\n>>> 1. SALVA AO RECEBER")
	var c := SliceCampaign.open(PATH)
	_expect("save novo abre sem bloqueio", not c.save_blocked and c.data["party"]["level"] == 1)
	c.data["party"]["level"] = LEVEL  # nível em que a rota é vencível (Argos), para haver loot no meio da run
	var run := c.start_expedition(BUILD, 21)
	_play(c, run, 1)
	_expect("um item chegou ao inventário no meio da run", c.inventory.items.size() >= 1 and run.state != "won" and run.state != "lost")
	var on_disk := SliceSave.read(PATH)
	_expect("o item já está no arquivo antes da run acabar", on_disk["ok"] and on_disk["data"]["inventory"]["items"].size() >= 1)
	_play(c, run)
	var summary := c.finish_expedition(run)
	_expect("primeira conclusão da Geleia Anciã concede Echo na campanha", c.inventory.echoes.has(SliceInventory.ECHO_SENTINEL))
	var again := SliceCampaign.open(PATH)
	_expect("reabrir preserva inventário e materiais", again.inventory.items.size() == c.inventory.items.size() and again.inventory.materials == c.inventory.materials)
	_expect("XP foi somado ao save", again.data["party"]["xp"] > 0 or again.data["party"]["level"] > LEVEL)
	_expect("resultado marca vitória apenas se venceu", summary["won"] == (run.state == "won") and again.data["boss_cleared"] == summary["won"])

func _test_lock_and_equipment() -> void:
	print("\n>>> 2. TRAVA E EQUIPAMENTO NA RUN")
	var c := SliceCampaign.open(PATH)
	var uid := c.inventory.add_item(LootRoller.make_instance("item_w_001", "Raro", 20, 5))
	_expect("equipar fora da run funciona", c.equip("hero_001", uid) == "")
	var run := c.start_expedition(BUILD, 5)
	_expect("expedição trava o inventário", c.inventory.locked and c.equip("hero_001", uid) == "locked")
	_expect("o run é criado", run != null)
	c.finish_expedition(run)
	_expect("terminar destrava", not c.inventory.locked)
	var fresh := c.inventory.add_item(LootRoller.make_instance("item_a_001", "Comum", 5, 1))
	var res := c.recycle(fresh)
	_expect("reciclar via campanha rende Resíduo e grava", res["ok"] and int(SliceSave.read(PATH)["data"]["inventory"]["materials"]["MAT_C1_LUMEN_RESIDUE"]) >= 1)

func _test_blocked_save() -> void:
	print("\n>>> 3. SAVE BLOQUEADO")
	var file := FileAccess.open(PATH, FileAccess.WRITE)
	file.store_string('{"version": 999}')
	file.close()
	var c := SliceCampaign.open(PATH)
	_expect("versão desconhecida bloqueia a gravação", c.save_blocked and c.save_error == "version")
	c.data["party"]["level"] = LEVEL
	var run := c.start_expedition(BUILD, 3)
	_play(c, run, 1)
	var check := FileAccess.open(PATH, FileAccess.READ)
	_expect("o arquivo desconhecido não é sobrescrito", check.get_as_text() == '{"version": 999}')
	_expect("o jogo segue em memória", c.inventory.items.size() >= 1)

func _test_echo_award_and_save() -> void:
	print("\n>>> 3. ECHO E PERSISTÊNCIA")
	var c := SliceCampaign.open(PATH)
	var echo_nodes: Array = SliceSession.data()["route"]["nodes"].filter(func(n): return String(n.get("kind", "")) == "ELITE")
	_expect("a elite declara o Echo como recompensa de primeira conclusão", echo_nodes.size() == 1 and String(echo_nodes[0].get("first_clear_echo", "")) == "echo_c1_001")
	c._apply([{"type": "encounter_cleared", "first_clear_echo": "echo_c1_001", "time": 0.0}])
	_expect("a primeira conclusão concede o Echo", c.inventory.echoes == ["echo_c1_001"])
	var disk := SliceSave.read(PATH)
	_expect("o Echo é salvo imediatamente", disk["ok"] and disk["data"]["inventory"].get("echoes", []) == ["echo_c1_001"])
	_expect("equipar o Echo no Refúgio funciona", c.equip_echo("echo_c1_001") == "")
	c._apply([{"type": "encounter_cleared", "first_clear_echo": "echo_c1_001", "time": 1.0}])
	var again := SliceCampaign.open(PATH)
	_expect("repetir a recompensa não duplica o Echo", again.inventory.echoes == ["echo_c1_001"])
	_expect("o Echo equipado persiste no save", again.inventory.equipped_echo == "echo_c1_001")
	var run := again.start_expedition(BUILD, 9)
	_expect("a campanha entrega o Echo equipado ao combate", run._equipped_echo == "echo_c1_001")
	again.finish_expedition(run)
