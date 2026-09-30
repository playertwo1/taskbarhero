extends RefCounted
class_name ItemStatView

const SliceItemStats := preload("res://scripts/combat/SliceItemStats.gd")
const SliceStats := preload("res://scripts/combat/SliceStats.gd")
const LootRoller := preload("res://scripts/run/LootRoller.gd")
const ItemIconResolver := preload("res://scripts/ui/ItemIconResolver.gd")

## Camada de apresentação única para números de itens (UI_S12).
## Implementa as regras de número de docs/09_ui/screens/s12_numeros_de_item.md:
## - Precisão total no cálculo, arredondamento só na tela.
## - Inteiros para Vida, Ataque, Defesa, Recarga e Tenacidade.
## - Abreviação a partir de 10.000 (10k, 12,4k, 100k, 124k).
## - Percentuais (Crítico, Velocidade) com uma casa decimal (1,5%).
## - Bônus positivo que arredonda a zero mostra "< 1".
## - Sinais (+11) e formas (▲ melhora, ▼ piora, = igual).
## Nenhuma constante de balanceamento fica em tela: tudo vem de SliceItemStats e BalanceProfiles.

const STAT_NAMES := {
	"attack": "Ataque",
	"max_hp": "Vida",
	"defense": "Defesa",
	"attack_speed": "Velocidade",
	"crit_chance": "Crítico",
	"skill_haste": "Recarga",
	"tenacity": "Tenacidade"
}

const STAT_GLYPHS := {
	"attack": "⚔",
	"max_hp": "❤",
	"defense": "🛡",
	"attack_speed": "⚡",
	"crit_chance": "🎯",
	"skill_haste": "⌛",
	"tenacity": "⛓"
}

const STAT_SHORTS := {
	"attack": "ATK",
	"max_hp": "HP",
	"defense": "DEF",
	"attack_speed": "VEL",
	"crit_chance": "CRIT",
	"skill_haste": "REC",
	"tenacity": "TEN"
}

const STAT_ORDER := [
	"attack",
	"max_hp",
	"defense",
	"attack_speed",
	"crit_chance",
	"skill_haste",
	"tenacity"
]

const PERCENT_STATS := ["crit_chance", "attack_speed"]

static var _cached_rows: Dictionary = {}
static var _cached_heroes: Dictionary = {}

static func _get_rows() -> Dictionary:
	if _cached_rows.is_empty():
		for row in SliceStats.load_rows("res://data/items/items.json", "slice"):
			_cached_rows[row["id"]] = row
	return _cached_rows

static func _get_hero_row(hero_id: String) -> Dictionary:
	if _cached_heroes.is_empty():
		var file := FileAccess.open("res://data/heroes/heroes.json", FileAccess.READ)
		if file != null:
			var arr = JSON.parse_string(file.get_as_text())
			if arr is Array:
				for h in arr:
					_cached_heroes[h["id"]] = h
	return _cached_heroes.get(hero_id, {})

## Formata um número com separador de milhar pt-BR (ex: 2393 -> "2.393").
static func _format_int_with_dots(n: int) -> String:
	var s := str(absi(n))
	var out := ""
	var length := s.length()
	for i in range(length):
		if i > 0 and (length - i) % 3 == 0:
			out += "."
		out += s[i]
	return ("-" if n < 0 else "") + out

## Regras 2, 3 e 4 de UI_S12:
## - Inteiro abaixo de 10.000: "2.393", "9.999"
## - 10.000 a 99.949: "10k", "12,4k"
## - 99.950 em diante: "100k", "124k"
## - percentual: "1,5%"
static func format_number(value: float, kind: String = "int") -> String:
	if kind == "percent":
		var abs_val := absf(value)
		var rounded_10 := roundi(abs_val * 10.0)
		var int_part := rounded_10 / 10
		var dec_part := rounded_10 % 10
		var sign_str := "-" if value < -0.00001 else ""
		return "%s%d,%d%%" % [sign_str, int_part, dec_part]

	# kind == "int"
	var abs_val := absf(value)
	var sign_str := "-" if value < -0.00001 else ""

	if abs_val < 10000.0:
		var rounded_int := roundi(abs_val)
		return sign_str + _format_int_with_dots(rounded_int)

	if abs_val < 99950.0:
		# Uma casa decimal com vírgula e k: "10k", "12,4k"
		var k_val := abs_val / 1000.0
		var rounded_10 := roundi(k_val * 10.0)
		var int_part := rounded_10 / 10
		var dec_part := rounded_10 % 10
		if int_part >= 100:
			return "%s%dk" % [sign_str, int_part]
		if dec_part == 0:
			return "%s%dk" % [sign_str, int_part]
		return "%s%d,%dk" % [sign_str, int_part, dec_part]

	# >= 99950 (mostra "100k", "124k", etc)
	var rounded_k := roundi(abs_val / 1000.0)
	return "%s%dk" % [sign_str, rounded_k]

## Regra 5 e 6:
## Bônus de item sempre com sinal ("+11", "+1,5%").
## Bônus positivo que arredonda a zero mostra "< 1" (ou "< 0,1%").
static func format_bonus_number(value: float, kind: String = "int") -> String:
	if kind == "percent":
		if value > 0.00001 and roundi(value * 10.0) == 0:
			return "< 0,1%"
		if value >= 0.0:
			return "+" + format_number(value, "percent")
		return format_number(value, "percent")

	# kind == "int"
	if value > 0.00001 and roundi(value) == 0:
		return "< 1"
	if value >= 0.0:
		return "+" + format_number(value, "int")
	return format_number(value, "int")

## Formata uma diferença com forma, sinal e variante.
static func format_diff(diff: float, kind: String = "int") -> Dictionary:
	if kind == "percent":
		var r10 := roundi(diff * 10.0)
		if r10 > 0:
			return {"shape": "▲", "sign": "+", "text": "▲ +" + format_number(diff, "percent"), "variant": "positive", "diff": diff}
		elif r10 < 0:
			var abs_diff := absf(diff)
			return {"shape": "▼", "sign": "-", "text": "▼ −" + format_number(abs_diff, "percent"), "variant": "negative", "diff": diff}
		else:
			return {"shape": "=", "sign": "", "text": "=", "variant": "neutral", "diff": diff}

	# kind == "int"
	var r := roundi(diff)
	if r > 0:
		return {"shape": "▲", "sign": "+", "text": "▲ +" + format_number(diff, "int"), "variant": "positive", "diff": diff}
	elif r < 0:
		var abs_diff := absf(diff)
		return {"shape": "▼", "sign": "-", "text": "▼ −" + format_number(abs_diff, "int"), "variant": "negative", "diff": diff}
	else:
		return {"shape": "=", "sign": "", "text": "=", "variant": "neutral", "diff": diff}

## Gera as linhas de bônus do item formatadas (C2 / C3).
static func lines(inst: Dictionary, rows: Dictionary = {}, profiles: Dictionary = {}) -> Array:
	var r := rows if not rows.is_empty() else _get_rows()
	var row: Dictionary = r.get(inst.get("id", ""), {})
	if row.is_empty():
		return []
	var rolled := SliceItemStats.roll(row, String(inst.get("rarity", "")), int(inst.get("item_power", 0)), int(inst.get("item_level", 0)), profiles)
	if rolled.is_empty():
		return []
	var reinforce_bonus: float = SliceItemStats.reinforce_bonus()
	var scale := 1.0 + reinforce_bonus * int(inst.get("reinforce", 0))

	var result: Array = []
	for stat in STAT_ORDER:
		if rolled.has(stat) and float(rolled[stat]) > 0.00001:
			var is_pct := PERCENT_STATS.has(stat)
			var kind := "percent" if is_pct else "int"
			var raw_scaled: float = float(rolled[stat]) * scale
			var display_val := raw_scaled * 100.0 if is_pct else raw_scaled
			var formatted_bonus := format_bonus_number(display_val, kind)
			var text := "%s %s" % [formatted_bonus, STAT_NAMES[stat]]
			var chip_text := "%s %s" % [STAT_GLYPHS[stat], formatted_bonus]
			result.append({
				"stat": stat,
				"name": STAT_NAMES[stat],
				"glyph": STAT_GLYPHS[stat],
				"short": STAT_SHORTS[stat],
				"kind": kind,
				"value": display_val,
				"raw_value": raw_scaled,
				"text": text,
				"chip_text": chip_text
			})
	return result

## Determina qual item equipado no herói seria substituído por inst.
## Regra de comparação:
## - Mesma vaga para Arma, Secundário, Armadura.
## - Menor pontuação (raridade, depois Item Power) para Acessório se tiver 2.
static func get_replaced_instance(inst: Dictionary, hero_id: String, campaign: SliceCampaign, rows: Dictionary = {}) -> Dictionary:
	if campaign == null or campaign.inventory == null:
		return {}
	var r := rows if not rows.is_empty() else _get_rows()
	var row: Dictionary = r.get(inst.get("id", ""), {})
	var slot := String(row.get("slot", ""))
	if slot == "":
		return {}
	var equipped_uids: Array = campaign.inventory.equipped.get(hero_id, [])
	var target_uid := int(inst.get("uid", 0))

	# Se já está equipado por este herói, substitui a si mesmo
	if equipped_uids.has(target_uid):
		return inst

	if slot != "accessory":
		for uid in equipped_uids:
			var eq_inst := campaign.inventory.find(int(uid))
			if r.get(eq_inst.get("id", ""), {}).get("slot", "") == slot:
				return eq_inst
		return {}

	# Acessório: se tiver menos de 2, vaga vazia (não substitui nenhum)
	var eq_accs: Array = []
	for uid in equipped_uids:
		var eq_inst := campaign.inventory.find(int(uid))
		if r.get(eq_inst.get("id", ""), {}).get("slot", "") == "accessory":
			eq_accs.append(eq_inst)
	if eq_accs.size() < 2:
		return {}

	# Menor score
	var lowest_inst: Dictionary = eq_accs[0]
	var lowest_score: int = LootRoller.rarity_rank(String(lowest_inst.get("rarity", ""))) * 1000 + int(lowest_inst.get("item_power", 0))
	for it in eq_accs.slice(1):
		var sc: int = LootRoller.rarity_rank(String(it.get("rarity", ""))) * 1000 + int(it.get("item_power", 0))
		if sc < lowest_score:
			lowest_score = sc
			lowest_inst = it
	return lowest_inst

## Compara o item contra o item atualmente equipado pelo herói (Regras de Comparação).
## A diferença exibida é a diferença entre os TOTAIS EXIBIDOS (arredondados), para a linha sempre fechar.
static func compare(inst: Dictionary, hero_id: String, campaign: SliceCampaign, rows: Dictionary = {}, profiles: Dictionary = {}) -> Dictionary:
	var r := rows if not rows.is_empty() else _get_rows()
	var row: Dictionary = r.get(inst.get("id", ""), {})
	if not row.get("compatible_heroes", []).has(hero_id):
		return {
			"compatible": false,
			"replaced_inst": {},
			"diffs": [],
			"primary_diff": null,
			"current_totals": {},
			"next_totals": {}
		}

	var hero_row := _get_hero_row(hero_id)
	var level := int(campaign.data.get("party", {}).get("level", 1)) if campaign != null else 1
	var base_stats := SliceStats.hero_stats(hero_row, level, profiles)

	var current_equipped: Array = []
	if campaign != null and campaign.inventory != null:
		for uid in campaign.inventory.equipped.get(hero_id, []):
			var it := campaign.inventory.find(int(uid))
			if not it.is_empty():
				current_equipped.append(it)

	var current_totals := SliceItemStats.equip(base_stats, hero_id, current_equipped, r.values(), -1.0, profiles)
	var replaced := get_replaced_instance(inst, hero_id, campaign, r)

	var next_equipped: Array = []
	for it in current_equipped:
		if not replaced.is_empty() and int(it.get("uid", 0)) == int(replaced.get("uid", 0)):
			continue
		next_equipped.append(it)
	if not next_equipped.any(func(it): return int(it.get("uid", 0)) == int(inst.get("uid", 0))):
		next_equipped.append(inst)

	var next_totals := SliceItemStats.equip(base_stats, hero_id, next_equipped, r.values(), -1.0, profiles)

	var diffs: Array = []
	var item_lines := lines(inst, r, profiles)
	var item_stats: Array = item_lines.map(func(l): return l["stat"])

	for stat in STAT_ORDER:
		var is_pct := PERCENT_STATS.has(stat)
		var kind := "percent" if is_pct else "int"
		var curr_f: float = float(current_totals[stat]) * (100.0 if is_pct else 1.0)
		var next_f: float = float(next_totals[stat]) * (100.0 if is_pct else 1.0)

		# Arredondamento do total exibido (Regra 90)
		var disp_curr: float = roundf(curr_f * 10.0) / 10.0 if is_pct else float(roundi(curr_f))
		var disp_next: float = roundf(next_f * 10.0) / 10.0 if is_pct else float(roundi(next_f))
		var diff_val := disp_next - disp_curr
		var diff_info := format_diff(diff_val, kind)

		diffs.append({
			"stat": stat,
			"name": STAT_NAMES[stat],
			"glyph": STAT_GLYPHS[stat],
			"short": STAT_SHORTS[stat],
			"kind": kind,
			"curr_val": disp_curr,
			"next_val": disp_next,
			"diff": diff_val,
			"diff_info": diff_info,
			"is_item_stat": item_stats.has(stat)
		})

	# Identifica primary_diff para o chip de linha (C2)
	var primary: Dictionary = {}
	# Prioridade: stat do item com diff != 0 na ordem de prioridade (attack, defense, max_hp, etc.)
	for stat_key in ["attack", "defense", "max_hp", "crit_chance", "attack_speed", "skill_haste", "tenacity"]:
		for d in diffs:
			if d["stat"] == stat_key and d["is_item_stat"] and absf(d["diff"]) > 0.0001:
				primary = d
				break
		if not primary.is_empty():
			break
	if primary.is_empty():
		for d in diffs:
			if absf(d["diff"]) > 0.0001:
				primary = d
				break
	if primary.is_empty() and not diffs.is_empty():
		primary = diffs[0]

	var primary_chip_text := ""
	if not primary.is_empty():
		var dinfo: Dictionary = primary["diff_info"]
		var diff_bonus := format_bonus_number(primary["diff"], primary["kind"])
		primary_chip_text = "%s %s %s" % [dinfo["shape"], diff_bonus, primary["short"]]

	return {
		"compatible": true,
		"replaced_inst": replaced,
		"diffs": diffs,
		"primary_diff": primary,
		"primary_chip_text": primary_chip_text,
		"current_totals": current_totals,
		"next_totals": next_totals
	}

## Totais do herói com e sem equipamento (para a Ficha e comparação).
static func hero_totals(hero_id: String, level: int, campaign: SliceCampaign, with_uid: int = -1, profiles: Dictionary = {}) -> Dictionary:
	var r := _get_rows()
	var hero_row := _get_hero_row(hero_id)
	var base_stats := SliceStats.hero_stats(hero_row, level, profiles)

	var current_equipped: Array = []
	if campaign != null and campaign.inventory != null:
		for uid in campaign.inventory.equipped.get(hero_id, []):
			var it := campaign.inventory.find(int(uid))
			if not it.is_empty():
				current_equipped.append(it)

	var current_totals := SliceItemStats.equip(base_stats, hero_id, current_equipped, r.values(), -1.0, profiles)

	var hypothetical_totals := {}
	if with_uid >= 0 and campaign != null and campaign.inventory != null:
		var target_inst := campaign.inventory.find(with_uid)
		if not target_inst.is_empty():
			var replaced := get_replaced_instance(target_inst, hero_id, campaign, r)
			var next_equipped: Array = []
			for it in current_equipped:
				if not replaced.is_empty() and int(it.get("uid", 0)) == int(replaced.get("uid", 0)):
					continue
				next_equipped.append(it)
			next_equipped.append(target_inst)
			hypothetical_totals = SliceItemStats.equip(base_stats, hero_id, next_equipped, r.values(), -1.0, profiles)

	var bonus_totals: Dictionary = {}
	for stat in STAT_ORDER:
		bonus_totals[stat] = float(current_totals[stat]) - float(base_stats[stat])

	return {
		"base": base_stats,
		"current": current_totals,
		"bonus": bonus_totals,
		"hypothetical": hypothetical_totals
	}

## Ficha de status do herói em 7 linhas (C4).
static func hero_sheet(hero_id: String, campaign: SliceCampaign, profiles: Dictionary = {}) -> Array:
	var level := int(campaign.data.get("party", {}).get("level", 1)) if campaign != null else 1
	var totals := hero_totals(hero_id, level, campaign, -1, profiles)
	var curr: Dictionary = totals["current"]
	var bonus: Dictionary = totals["bonus"]

	var lines_out: Array = []
	for stat in STAT_ORDER:
		var is_pct := PERCENT_STATS.has(stat)
		var kind := "percent" if is_pct else "int"
		var curr_f: float = float(curr[stat]) * (100.0 if is_pct else 1.0)
		var bonus_f: float = float(bonus[stat]) * (100.0 if is_pct else 1.0)

		var total_text := format_number(curr_f, kind)
		var bonus_text := ""
		if absf(bonus_f) > 0.0001:
			bonus_text = "(%s)" % format_bonus_number(bonus_f, kind)

		var line_text := "%s %s %s%s" % [STAT_GLYPHS[stat], STAT_NAMES[stat], total_text, (" " + bonus_text) if bonus_text != "" else ""]
		lines_out.append({
			"stat": stat,
			"name": STAT_NAMES[stat],
			"glyph": STAT_GLYPHS[stat],
			"kind": kind,
			"total": curr_f,
			"bonus": bonus_f,
			"total_text": total_text,
			"bonus_text": bonus_text,
			"line_text": line_text
		})
	return lines_out

# -----------------------------------------------------------------------------
# Componentes Visuais (C1, C4, C5, C6)
# -----------------------------------------------------------------------------

## C1 — Chip de status (pílula neutra, positiva ou negativa).
static func create_stat_chip(text: String, glyph: String = "", variant: String = "neutral") -> PanelContainer:
	var chip := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.set_corner_radius_all(4)
	style.content_margin_left = 6
	style.content_margin_right = 6
	style.content_margin_top = 2
	style.content_margin_bottom = 2

	var label_color: Color
	match variant:
		"positive":
			style.bg_color = Color(0.08, 0.18, 0.12, 0.95)
			style.border_color = Color(0.24, 0.65, 0.35, 0.8)
			style.set_border_width_all(1)
			label_color = Color(0.45, 0.92, 0.55)
		"negative":
			style.bg_color = Color(0.22, 0.08, 0.1, 0.95)
			style.border_color = Color(0.72, 0.25, 0.28, 0.8)
			style.set_border_width_all(1)
			label_color = Color(0.95, 0.45, 0.48)
		_:
			style.bg_color = Color(0.1, 0.12, 0.15, 0.9)
			style.border_color = Color(0.25, 0.28, 0.32, 0.6)
			style.set_border_width_all(1)
			label_color = Color(0.85, 0.86, 0.88)

	chip.add_theme_stylebox_override("panel", style)
	chip.custom_minimum_size.y = 24

	var label := Label.new()
	label.text = (glyph + " " if glyph != "" else "") + text
	label.add_theme_font_size_override("font_size", 13)
	label.add_theme_color_override("font_color", label_color)
	chip.add_child(label)
	return chip

## C4 — Cria a Ficha Visual do Herói (7 linhas).
static func create_hero_sheet_control(hero_id: String, campaign: SliceCampaign) -> Control:
	var panel := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.05, 0.06, 0.08, 0.9)
	style.border_color = Color(0.18, 0.22, 0.26, 0.6)
	style.set_border_width_all(1)
	style.set_corner_radius_all(6)
	style.content_margin_left = 10
	style.content_margin_right = 10
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	panel.add_theme_stylebox_override("panel", style)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 3)

	var title := Label.new()
	title.text = "Status de Combate"
	title.add_theme_font_size_override("font_size", 14)
	title.add_theme_color_override("font_color", Color(0.85, 0.75, 0.45))
	vbox.add_child(title)

	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 16)
	grid.add_theme_constant_override("v_separation", 2)

	var sheet_lines := hero_sheet(hero_id, campaign)
	for l in sheet_lines:
		var lbl_name := Label.new()
		lbl_name.text = "%s %s" % [l["glyph"], l["name"]]
		lbl_name.add_theme_font_size_override("font_size", 13)
		lbl_name.add_theme_color_override("font_color", Color(0.75, 0.77, 0.8))
		grid.add_child(lbl_name)

		var lbl_val := Label.new()
		lbl_val.text = "%s %s" % [l["total_text"], l["bonus_text"]]
		lbl_val.add_theme_font_size_override("font_size", 13)
		lbl_val.add_theme_color_override("font_color", Color(0.92, 0.93, 0.95))
		grid.add_child(lbl_val)

	vbox.add_child(grid)
	panel.add_child(vbox)
	return panel

## C5 — Painel de Prévia do Reforço (Ferreiro).
static func create_reinforce_preview_box(inst: Dictionary, rows: Dictionary = {}) -> Control:
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 4)

	var r := rows if not rows.is_empty() else _get_rows()
	var row: Dictionary = r.get(inst.get("id", ""), {})
	if row.is_empty():
		return box

	var current_reinforce: int = int(inst.get("reinforce", 0))
	var next_reinforce: int = current_reinforce + 1
	var reinforce_bonus: float = SliceItemStats.reinforce_bonus()

	var rolled := SliceItemStats.roll(row, String(inst.get("rarity", "")), int(inst.get("item_power", 0)), int(inst.get("item_level", 0)))
	if rolled.is_empty():
		return box

	var header := Label.new()
	header.text = "Prévia do Reforço (+%d → +%d):" % [current_reinforce, next_reinforce]
	header.add_theme_font_size_override("font_size", 13)
	header.add_theme_color_override("font_color", Color(0.85, 0.75, 0.45))
	box.add_child(header)

	var preview_row := HBoxContainer.new()
	preview_row.add_theme_constant_override("separation", 10)

	var scale_curr := 1.0 + reinforce_bonus * current_reinforce
	var scale_next := 1.0 + reinforce_bonus * next_reinforce

	for stat in STAT_ORDER:
		if rolled.has(stat) and float(rolled[stat]) > 0.00001:
			var is_pct := PERCENT_STATS.has(stat)
			var kind := "percent" if is_pct else "int"
			var v_curr := float(rolled[stat]) * scale_curr * (100.0 if is_pct else 1.0)
			var v_next := float(rolled[stat]) * scale_next * (100.0 if is_pct else 1.0)
			var chip_txt := "%s %s → %s" % [STAT_NAMES[stat], format_bonus_number(v_curr, kind), format_bonus_number(v_next, kind)]
			var chip := create_stat_chip(chip_txt, STAT_GLYPHS[stat], "positive")
			preview_row.add_child(chip)

	box.add_child(preview_row)
	return box

## C6 — Cartão compacto para Escolha e Resultado.
static func create_compact_card(inst: Dictionary, rows: Dictionary = {}) -> Control:
	var panel := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.06, 0.08, 0.1, 0.9)
	style.border_color = Color(0.2, 0.23, 0.26, 0.6)
	style.set_border_width_all(1)
	style.set_corner_radius_all(6)
	style.content_margin_left = 8
	style.content_margin_right = 8
	style.content_margin_top = 6
	style.content_margin_bottom = 6
	panel.add_theme_stylebox_override("panel", style)

	var r := rows if not rows.is_empty() else _get_rows()
	var row: Dictionary = r.get(inst.get("id", ""), {})
	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 4)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 8)

	var icon := ItemIconResolver.create_icon_rect(String(inst.get("id", "")), Vector2(36, 36))
	header.add_child(icon)

	var name_lbl := Label.new()
	name_lbl.text = String(row.get("name", inst.get("id", "")))
	name_lbl.add_theme_font_size_override("font_size", 14)
	name_lbl.add_theme_color_override("font_color", ItemIconResolver.rarity_color(String(inst.get("rarity", "Comum"))))
	header.add_child(name_lbl)
	vbox.add_child(header)

	var chips_row := HBoxContainer.new()
	chips_row.add_theme_constant_override("separation", 6)
	var item_lines := lines(inst, r)
	for i in mini(2, item_lines.size()):
		var l: Dictionary = item_lines[i]
		chips_row.add_child(create_stat_chip(format_bonus_number(l["value"], l["kind"]), l["glyph"], "neutral"))
	vbox.add_child(chips_row)

	panel.add_child(vbox)
	return panel
