extends Control

var hero_hp_ratio: float = 1.0
var enemy_hp_ratio: float = 1.0
var enemy_is_boss: bool = false
var hero_attack_flash: float = 0.0
var enemy_attack_flash: float = 0.0
var loot_flash: float = 0.0
var enemy_name: String = "Inimigo"
var current_enemy_id: String = ""
var current_enemy_scene_id: String = ""

# Cenas dos 3 heróis da party
const BASTIAO_SCENE = preload("res://scenes/heroes/Bastiao.tscn")
const IRIS_SCENE = preload("res://scenes/heroes/Iris.tscn")
const FLECHA_SCENE = preload("res://scenes/heroes/Flecha.tscn")

# Cenas dos inimigos do Bosque de Lúmen
const SLIME_SCENE = preload("res://scenes/enemies/GeleiaDeLumen.tscn")
const GREMLIN_SCENE = preload("res://scenes/enemies/GremlinDeFolha.tscn")
const JAVALI_SCENE = preload("res://scenes/enemies/JavaliDeMusgo.tscn")
const ESPIRITO_SCENE = preload("res://scenes/enemies/EspiritoDeRaiz.tscn")
const LOBO_SCENE = preload("res://scenes/enemies/LoboAlfaDeLumen.tscn")
const CERVO_SCENE = preload("res://scenes/enemies/GuardiaoCervoDePedra.tscn")

# Cenário em 5 camadas (Zero mixels, AMOLED, estética Bosque de Lúmen)
const TEX_BG_DISTANT = preload("res://assets/sprites/environment/bosque_lumen/bg_distant.png")
const TEX_MID_TREES = preload("res://assets/sprites/environment/bosque_lumen/mid_trees.png")
const TEX_GROUND_STRIP = preload("res://assets/sprites/environment/bosque_lumen/ground_strip.png")
const TEX_FG_ELEMENTS = preload("res://assets/sprites/environment/bosque_lumen/fg_elements.png")

var party_visuals: Dictionary = {}
var hero_visual: Node2D = null # Alias para Bastião (retrocompatibilidade)
var enemy_visual: Node2D = null
var anim_time: float = 0.0

# Posicionamento horizontal de formação (sem sobreposição, escala 2.0x uniforme)
const FORMATION_X_FACTORS := {
	"flecha": 0.11,  # Slot back (arqueiro)
	"iris": 0.24,    # Slot mid (maga)
	"bastiao": 0.38  # Slot front (tanque)
}

func _ready() -> void:
	custom_minimum_size = Vector2(0, 220)
	set_process(true)
	_setup_party()

func _setup_party() -> void:
	var hero_scenes := {
		"flecha": FLECHA_SCENE,
		"iris": IRIS_SCENE,
		"bastiao": BASTIAO_SCENE
	}
	
	for hid in ["flecha", "iris", "bastiao"]:
		if not party_visuals.has(hid) or party_visuals[hid] == null or not is_instance_valid(party_visuals[hid]):
			var inst = hero_scenes[hid].instantiate()
			add_child(inst)
			party_visuals[hid] = inst
		var node: Node2D = party_visuals[hid]
		node.scale = Vector2(2.0, 2.0)
		node.visible = true
		if node.has_method("reset"):
			node.reset()
			
	hero_visual = party_visuals.get("bastiao")

func _setup_hero() -> void:
	_setup_party()

func _process(delta: float) -> void:
	anim_time += delta
	hero_attack_flash = maxf(0.0, hero_attack_flash - delta * 4.0)
	enemy_attack_flash = maxf(0.0, enemy_attack_flash - delta * 4.0)
	loot_flash = maxf(0.0, loot_flash - delta * 2.0)
	
	var ground_y := size.y - 42.0
	
	# Posiciona todos os 3 heróis da party em suas respectivas formações
	for hid in party_visuals.keys():
		var node: Node2D = party_visuals[hid]
		if node and is_instance_valid(node) and node.visible:
			var hx: float = size.x * float(FORMATION_X_FACTORS.get(hid, 0.25))
			node.position = Vector2(hx, ground_y)
		
	if enemy_visual and is_instance_valid(enemy_visual) and enemy_visual.visible:
		var enemy_x := size.x * 0.74
		enemy_visual.position = Vector2(enemy_x, ground_y)
		
	queue_redraw()

func set_enemy(enemy_data: Dictionary) -> void:
	current_enemy_id = enemy_data.get("id", "")
	enemy_name = enemy_data.get("name", "Inimigo")
	enemy_is_boss = enemy_data.get("boss", false)
	
	var target_scene: PackedScene = null
	match current_enemy_id:
		"geleia_de_lumen":
			target_scene = SLIME_SCENE
		"gremlin_de_folha":
			target_scene = GREMLIN_SCENE
		"javali_de_musgo":
			target_scene = JAVALI_SCENE
		"espirito_de_raiz":
			target_scene = ESPIRITO_SCENE
		"lobo_alfa_de_lumen":
			target_scene = LOBO_SCENE
		"guardiao_cervo_de_pedra":
			target_scene = CERVO_SCENE
	
	if target_scene != null:
		if enemy_visual == null or not is_instance_valid(enemy_visual) or current_enemy_scene_id != current_enemy_id:
			if enemy_visual and is_instance_valid(enemy_visual):
				enemy_visual.queue_free()
			enemy_visual = target_scene.instantiate()
			add_child(enemy_visual)
			current_enemy_scene_id = current_enemy_id
		
		enemy_visual.visible = true
		if enemy_visual.has_method("reset"):
			enemy_visual.reset()
		enemy_visual.scale = Vector2(2.0, 2.0)
	else:
		if enemy_visual and is_instance_valid(enemy_visual):
			enemy_visual.visible = false

func play_hero_attack(hero_id: String) -> void:
	hero_attack_flash = 1.0
	if party_visuals.has(hero_id):
		var node: Node2D = party_visuals[hero_id]
		if node and is_instance_valid(node) and node.visible:
			if node.has_method("play_attack"):
				node.play_attack()
	if enemy_visual and is_instance_valid(enemy_visual) and enemy_visual.visible:
		if enemy_visual.has_method("play_hit"):
			enemy_visual.play_hit()

func play_hero_hit(hero_id: String) -> void:
	if party_visuals.has(hero_id):
		var node: Node2D = party_visuals[hero_id]
		if node and is_instance_valid(node) and node.visible:
			if node.has_method("play_hit"):
				node.play_hit()

func play_hero_death_single(hero_id: String) -> void:
	if party_visuals.has(hero_id):
		var node: Node2D = party_visuals[hero_id]
		if node and is_instance_valid(node) and node.visible:
			if node.has_method("play_death"):
				node.play_death()

func reset_hero_single(hero_id: String) -> void:
	if party_visuals.has(hero_id):
		var node: Node2D = party_visuals[hero_id]
		if node and is_instance_valid(node):
			if node.has_method("reset"):
				node.reset()

func flash_hero_attack() -> void:
	# Wrapper legado: seleciona o atacante vivo prioritário
	var attacker := "bastiao"
	if GameManager.party.has("bastiao") and not GameManager.party["bastiao"]["is_alive"]:
		if GameManager.party.has("iris") and GameManager.party["iris"]["is_alive"]:
			attacker = "iris"
		elif GameManager.party.has("flecha") and GameManager.party["flecha"]["is_alive"]:
			attacker = "flecha"
	play_hero_attack(attacker)

func flash_enemy_attack() -> void:
	enemy_attack_flash = 1.0
	if enemy_visual and is_instance_valid(enemy_visual) and enemy_visual.visible:
		if enemy_visual.has_method("play_attack"):
			enemy_visual.play_attack()
	var target_id := GameManager._get_enemy_target()
	if target_id != "":
		play_hero_hit(target_id)
	elif hero_visual and is_instance_valid(hero_visual) and hero_visual.visible:
		if hero_visual.has_method("play_hit"):
			hero_visual.play_hit()

func play_enemy_death() -> void:
	if enemy_visual and is_instance_valid(enemy_visual) and enemy_visual.visible:
		if enemy_visual.has_method("play_death"):
			enemy_visual.play_death()

func play_hero_death() -> void:
	for hid in party_visuals.keys():
		var node: Node2D = party_visuals[hid]
		if node and is_instance_valid(node) and node.visible:
			if node.has_method("play_death"):
				node.play_death()

func reset_hero() -> void:
	for hid in party_visuals.keys():
		var node: Node2D = party_visuals[hid]
		if node and is_instance_valid(node):
			if node.has_method("reset"):
				node.reset()

func flash_loot() -> void:
	loot_flash = 1.0

func _draw() -> void:
	var s := size
	var ground_y := s.y - 42.0

	# 1. Fundo Distante (Camada 1: Céu AMOLED, montanhas e bruma esmeralda)
	draw_texture_rect(TEX_BG_DISTANT, Rect2(Vector2.ZERO, s), false)

	# 2. Camada Intermediária (Camada 2: Troncos ancestrais, ruínas de pedra e galhos)
	draw_texture_rect(TEX_MID_TREES, Rect2(Vector2.ZERO, s), false)

	# 3. Partículas flutuantes de Lúmen cintilante (orbes bioluminescentes vivos)
	for i in range(6):
		var seed_offset := float(i) * 1.618
		var px := fmod(s.x * (0.12 + float(i) * 0.15) + sin(anim_time * 1.5 + seed_offset) * 10.0, s.x)
		var py := 45.0 + sin(anim_time * 2.0 + seed_offset * 2.0) * 18.0
		var radius := 2.5 + sin(anim_time * 3.0 + seed_offset) * 1.0
		var col := Color("56d364", 0.45 + sin(anim_time * 2.5 + seed_offset) * 0.25)
		draw_circle(Vector2(px, py), radius, col)

	# 4. Solo / Ground Strip musgoso (Camada 3: terra batida, raízes e musgo iluminado)
	draw_texture_rect(TEX_GROUND_STRIP, Rect2(0, ground_y, s.x, 42), false)

	# 5. Elementos Frontais Recortados (Camada 4: samambaias e cogumelos luminosos na borda)
	draw_texture_rect(TEX_FG_ELEMENTS, Rect2(0, s.y - 24, s.x, 24), false)

	# 6. Barras de Vida Macro (Topo da faixa)
	var party_macro_x := s.x * 0.24
	var enemy_macro_x := s.x * 0.74
	_draw_health_bar(Rect2(party_macro_x - 70, 16, 140, 10), hero_hp_ratio, Color("48c774"))
	_draw_health_bar(Rect2(enemy_macro_x - 70, 16, 140, 10), enemy_hp_ratio, Color("f14668") if not enemy_is_boss else Color("e040fb"))

	# 7. Barras de Vida Individuais sobre a cabeça de cada herói (micro-status)
	for hid in ["flecha", "iris", "bastiao"]:
		var hx: float = s.x * float(FORMATION_X_FACTORS.get(hid, 0.25))
		var bar_rect := Rect2(hx - 22, ground_y - 72, 44, 4)
		var is_alive: bool = GameManager.party.get(hid, {}).get("is_alive", true)
		var cur_hp: float = GameManager.party.get(hid, {}).get("current_hp", 100.0)
		var max_hp: float = GameManager.get_hero_max_hp(hid)
		var ratio: float = cur_hp / max_hp if max_hp > 0.0 else 0.0

		if is_alive:
			var bar_col := Color("48c774")
			if ratio <= 0.25:
				bar_col = Color("f14668")
			elif ratio <= 0.50:
				bar_col = Color("ffdd57")
			_draw_health_bar(bar_rect, ratio, bar_col)
		else:
			# Indicador compacto de nocaute temporário
			draw_rect(bar_rect, Color("20232a", 0.8), true)
			draw_line(Vector2(hx - 6, ground_y - 72), Vector2(hx + 6, ground_y - 68), Color("f14668", 0.9), 1.5)
			draw_line(Vector2(hx + 6, ground_y - 72), Vector2(hx - 6, ground_y - 68), Color("f14668", 0.9), 1.5)

	# 8. Efeito de Loot Flash
	if loot_flash > 0.0:
		var r := 9.0 + loot_flash * 4.0
		draw_circle(Vector2(s.x * 0.56, ground_y - 16), r, Color("ffdd57", 0.50 + loot_flash * 0.40))

func _draw_health_bar(rect: Rect2, ratio: float, fill_color: Color) -> void:
	draw_rect(rect, Color("15181e"), true)
	draw_rect(rect, Color("2c313a"), false, 1.0)
	var clamped := clampf(ratio, 0.0, 1.0)
	if clamped > 0.0:
		draw_rect(Rect2(rect.position.x + 1, rect.position.y + 1, (rect.size.x - 2) * clamped, rect.size.y - 2), fill_color, true)
