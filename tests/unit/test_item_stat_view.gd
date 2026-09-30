extends Node

const ItemStatView := preload("res://scripts/ui/ItemStatView.gd")
const SliceStats := preload("res://scripts/combat/SliceStats.gd")
const LootRoller := preload("res://scripts/run/LootRoller.gd")
const SliceCampaign := preload("res://scripts/run/SliceCampaign.gd")

var success := true

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] %s" % label)
	else:
		print("FALHA: %s" % label)
		success = false

func _ready() -> void:
	print("--- TESTE ITEM STAT VIEW (UI_S12) ---")
	_test_number_formatting()
	_test_item_lines()
	_test_hero_sheet()
	_test_comparison_and_equipment_delta()
	_test_accessory_replacement_rule()
	_test_reinforce_preview()

	print("=======================================================")
	print("[%s] TESTE ITEM STAT VIEW" % ("PASS" if success else "FAIL"))
	get_tree().quit(0 if success else 1)

func _test_number_formatting() -> void:
	print("\n>>> 1. REGRAS DE FORMATAÇÃO DE NÚMEROS (UI_S12 §Regras)")
	# 9.999
	_expect("9.999 formata com separador de milhar", ItemStatView.format_number(9999, "int") == "9.999")
	# 2.393
	_expect("2.393 formata com separador de milhar", ItemStatView.format_number(2393, "int") == "2.393")
	# 147
	_expect("147 formata como inteiro", ItemStatView.format_number(147, "int") == "147")
	# 10.000 -> 10k
	_expect("10.000 abrevia para 10k", ItemStatView.format_number(10000, "int") == "10k")
	# 12.350 -> 12,4k
	_expect("12.350 abrevia para 12,4k", ItemStatView.format_number(12350, "int") == "12,4k")
	# 99.950 -> 100k
	_expect("99.950 arredonda para 100k", ItemStatView.format_number(99950, "int") == "100k")
	# 124.000 -> 124k
	_expect("124.000 abrevia para 124k", ItemStatView.format_number(124000, "int") == "124k")
	# 0,4 -> < 1 (Regra 5: bônus positivo que arredonda para 0 mostra < 1)
	_expect("bônus 0.4 mostra < 1", ItemStatView.format_bonus_number(0.4, "int") == "< 1")
	_expect("bônus 11 mostra +11", ItemStatView.format_bonus_number(11, "int") == "+11")
	# percentual: 1.5%
	_expect("percentual 1.5 mostra 1,5%", ItemStatView.format_number(1.5, "percent") == "1,5%")
	_expect("bônus percentual 1.5 mostra +1,5%", ItemStatView.format_bonus_number(1.5, "percent") == "+1,5%")
	# números negativos
	_expect("-2.393 formata negativo com milhar", ItemStatView.format_number(-2393, "int") == "-2.393")
	_expect("-12.350 formata negativo abreviado", ItemStatView.format_number(-12350, "int") == "-12,4k")

func _test_item_lines() -> void:
	print("\n>>> 2. LINHAS DE BÔNUS DO ITEM (C2 / C3)")
	var rows: Dictionary = {}
	for r in SliceStats.load_rows("res://data/items/items.json", "slice"):
		rows[r["id"]] = r

	# Galho de Vigília Raro, IP 27, Nível 10
	var sword_rare := LootRoller.make_instance("item_w_001", "Raro", 27, 10)
	var sword_lines := ItemStatView.lines(sword_rare, rows)
	_expect("Galho Raro tem linhas de bônus", not sword_lines.is_empty())
	var has_atk := false
	var has_def := false
	for l in sword_lines:
		if l["stat"] == "attack":
			has_atk = true
			_expect("Galho Raro Ataque é +11", l["text"].contains("+11") and l["chip_text"].contains("+11"))
		if l["stat"] == "defense":
			has_def = true
			_expect("Galho Raro Defesa é +4", l["text"].contains("+4") and l["chip_text"].contains("+4"))
	_expect("Galho Raro possui Ataque e Defesa", has_atk and has_def)

	# Olho de Vidro Verde (Acessório Raro: Crítico e Ataque)
	var eye_rare := LootRoller.make_instance("item_r_004", "Raro", 27, 10)
	var eye_lines := ItemStatView.lines(eye_rare, rows)
	var has_crit := false
	for l in eye_lines:
		if l["stat"] == "crit_chance":
			has_crit = true
			_expect("Olho Raro tem bônus de crítico percentual (+1,5% Crítico)", l["text"].contains("1,5%") and l["kind"] == "percent")
	_expect("Olho Raro possui Crítico", has_crit)

func _test_hero_sheet() -> void:
	print("\n>>> 3. FICHA DE STATUS DO HERÓI (C4)")
	var c := SliceCampaign.in_memory()
	c.data["party"]["level"] = 10
	var sheet := ItemStatView.hero_sheet("hero_001", c)
	_expect("Ficha do herói tem exatamente 7 status", sheet.size() == 7)
	# Sem equipamento, não há bônus entre parênteses
	for l in sheet:
		_expect("Sem equipamento bônus é vazio", l["bonus_text"] == "")

	# Equipa um Galho Comum em Bastião
	var sword_comum_uid := c.inventory.add_item(LootRoller.make_instance("item_w_001", "Comum", 27, 10))
	c.inventory.equip("hero_001", sword_comum_uid)
	var sheet_with_gear := ItemStatView.hero_sheet("hero_001", c)
	var atk_line: Dictionary = {}
	for l in sheet_with_gear:
		if l["stat"] == "attack":
			atk_line = l
			break
	_expect("Com equipamento Ataque mostra bônus entre parênteses", atk_line["bonus_text"] != "" and atk_line["line_text"].contains("(+"))

func _test_comparison_and_equipment_delta() -> void:
	print("\n>>> 4. COMPARAÇÃO E TOTAL DO HERÓI (C2 / C3)")
	var rows: Dictionary = {}
	for r in SliceStats.load_rows("res://data/items/items.json", "slice"):
		rows[r["id"]] = r

	var c := SliceCampaign.in_memory()
	c.data["party"]["level"] = 10

	# Bastião começa com Galho Comum IP 27 Nível 10
	var comum_uid := c.inventory.add_item(LootRoller.make_instance("item_w_001", "Comum", 27, 10))
	c.inventory.equip("hero_001", comum_uid)

	# Novo item a comparar: Galho Raro IP 27 Nível 10
	var rare_inst := LootRoller.make_instance("item_w_001", "Raro", 27, 10)
	rare_inst["uid"] = 999

	var comp := ItemStatView.compare(rare_inst, "hero_001", c, rows)
	_expect("Galho Raro é compatível com Bastião", comp["compatible"])
	_expect("Substitui o Galho Comum equipado", int(comp["replaced_inst"].get("uid", 0)) == comum_uid)

	# Validação dos exemplos do contrato UI_S12 (§Exemplos reproduzíveis):
	# "Trocar o Galho Comum pelo Raro em Bastião mostra Ataque 151 → 158 (▲ +7) e Defesa 272 → 275 (▲ +3)"
	var atk_diff: Dictionary = {}
	var def_diff: Dictionary = {}
	for d in comp["diffs"]:
		if d["stat"] == "attack":
			atk_diff = d
		if d["stat"] == "defense":
			def_diff = d

	_expect("Ataque atual exibido é 151", int(atk_diff["curr_val"]) == 151)
	_expect("Ataque próximo exibido é 158", int(atk_diff["next_val"]) == 158)
	_expect("Diferença de Ataque fecha a conta (+7)", int(atk_diff["diff"]) == 7)
	_expect("Ataque tem forma de melhora ▲", atk_diff["diff_info"]["shape"] == "▲")

	_expect("Defesa atual exibida é 272", int(def_diff["curr_val"]) == 272)
	_expect("Defesa próxima exibida é 275", int(def_diff["next_val"]) == 275)
	_expect("Diferença de Defesa fecha a conta (+3)", int(def_diff["diff"]) == 3)
	_expect("Defesa tem forma de melhora ▲", def_diff["diff_info"]["shape"] == "▲")

	# Chip principal de linha (C2)
	_expect("Chip de linha destaca ganho de ataque (▲ +7 ATK)", comp["primary_chip_text"].contains("▲") and comp["primary_chip_text"].contains("7") and comp["primary_chip_text"].contains("ATK"))

func _test_accessory_replacement_rule() -> void:
	print("\n>>> 5. REGRA DE SUBSTITUIÇÃO DE ACESSÓRIOS (UI_S12 §Regras de comparação)")
	var rows: Dictionary = {}
	for r in SliceStats.load_rows("res://data/items/items.json", "slice"):
		rows[r["id"]] = r

	var c := SliceCampaign.in_memory()
	c.data["party"]["level"] = 10

	# Equipa 1 acessório (Gota Comum IP 10)
	var acc1_uid := c.inventory.add_item(LootRoller.make_instance("item_r_001", "Comum", 10, 10))
	c.inventory.equip("hero_001", acc1_uid)

	# Com apenas 1 acessório equipado, novo acessório não substitui nenhum (vaga aberta)
	var acc_new := LootRoller.make_instance("item_r_004", "Raro", 27, 10)
	acc_new["uid"] = 888
	var comp1 := ItemStatView.compare(acc_new, "hero_001", c, rows)
	_expect("Com 1 acessório equipado, não substitui nenhum (vaga vazia)", comp1["replaced_inst"].is_empty())

	# Equipa o 2º acessório (Olho Raro IP 25)
	var acc2_uid := c.inventory.add_item(LootRoller.make_instance("item_r_004", "Raro", 25, 10))
	c.inventory.equip("hero_001", acc2_uid)

	# Agora com 2 acessórios, um 3º acessório deve substituir o de menor score (Gota Comum, score menor que Olho Raro)
	var comp2 := ItemStatView.compare(acc_new, "hero_001", c, rows)
	_expect("Com 2 acessórios, substitui o de menor score (acc1 Comum)", int(comp2["replaced_inst"].get("uid", 0)) == acc1_uid)

func _test_reinforce_preview() -> void:
	print("\n>>> 6. PRÉVIA DO REFORÇO (C5)")
	var inst := LootRoller.make_instance("item_w_001", "Raro", 27, 10)
	inst["reinforce"] = 0
	var preview := ItemStatView.create_reinforce_preview_box(inst)
	_expect("Painel de prévia de reforço criado com sucesso", preview != null and preview.get_child_count() > 0)
	preview.free()
