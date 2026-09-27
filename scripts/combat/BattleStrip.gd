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

const BASTIAO_SCENE = preload("res://scenes/heroes/Bastiao.tscn")
const SLIME_SCENE = preload("res://scenes/enemies/GeleiaDeLumen.tscn")
const GREMLIN_SCENE = preload("res://scenes/enemies/GremlinDeFolha.tscn")
const JAVALI_SCENE = preload("res://scenes/enemies/JavaliDeMusgo.tscn")
const ESPIRITO_SCENE = preload("res://scenes/enemies/EspiritoDeRaiz.tscn")
const LOBO_SCENE = preload("res://scenes/enemies/LoboAlfaDeLumen.tscn")
const CERVO_SCENE = preload("res://scenes/enemies/GuardiaoCervoDePedra.tscn")

const TEX_BG_DISTANT = preload("res://assets/sprites/environment/bosque_lumen/bg_distant.png")
const TEX_MID_TREES = preload("res://assets/sprites/environment/bosque_lumen/mid_trees.png")
const TEX_GROUND_STRIP = preload("res://assets/sprites/environment/bosque_lumen/ground_strip.png")
const TEX_FG_ELEMENTS = preload("res://assets/sprites/environment/bosque_lumen/fg_elements.png")

var enemy_visual: Node2D = null
var hero_visual: Node2D = null
var anim_time: float = 0.0

func _ready() -> void:
	custom_minimum_size = Vector2(0, 220)
	set_process(true)
	_setup_hero()

func _setup_hero() -> void:
	if hero_visual == null or not is_instance_valid(hero_visual):
		hero_visual = BASTIAO_SCENE.instantiate()
		add_child(hero_visual)
	hero_visual.scale = Vector2(2.0, 2.0)
	hero_visual.visible = true
	if hero_visual.has_method("reset"):
		hero_visual.reset()

func _process(delta: float) -> void:
	anim_time += delta
	hero_attack_flash = maxf(0.0, hero_attack_flash - delta * 4.0)
	enemy_attack_flash = maxf(0.0, enemy_attack_flash - delta * 4.0)
	loot_flash = maxf(0.0, loot_flash - delta * 2.0)
	
	var ground_y := size.y - 42.0
	
	if hero_visual and is_instance_valid(hero_visual) and hero_visual.visible:
		var hero_x := size.x * 0.25
		hero_visual.position = Vector2(hero_x, ground_y)
		
	if enemy_visual and is_instance_valid(enemy_visual) and enemy_visual.visible:
		var enemy_x := size.x * 0.73
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

func flash_hero_attack() -> void:
	hero_attack_flash = 1.0
	if hero_visual and is_instance_valid(hero_visual) and hero_visual.visible:
		if hero_visual.has_method("play_attack"):
			hero_visual.play_attack()
	if enemy_visual and is_instance_valid(enemy_visual) and enemy_visual.visible:
		if enemy_visual.has_method("play_hit"):
			enemy_visual.play_hit()

func flash_enemy_attack() -> void:
	enemy_attack_flash = 1.0
	if enemy_visual and is_instance_valid(enemy_visual) and enemy_visual.visible:
		if enemy_visual.has_method("play_attack"):
			enemy_visual.play_attack()
	if hero_visual and is_instance_valid(hero_visual) and hero_visual.visible:
		if hero_visual.has_method("play_hit"):
			hero_visual.play_hit()

func play_enemy_death() -> void:
	if enemy_visual and is_instance_valid(enemy_visual) and enemy_visual.visible:
		if enemy_visual.has_method("play_death"):
			enemy_visual.play_death()

func play_hero_death() -> void:
	if hero_visual and is_instance_valid(hero_visual) and hero_visual.visible:
		if hero_visual.has_method("play_death"):
			hero_visual.play_death()

func reset_hero() -> void:
	if hero_visual and is_instance_valid(hero_visual):
		if hero_visual.has_method("reset"):
			hero_visual.reset()

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

	var hero_x := s.x * 0.25
	var enemy_x := s.x * 0.73

	# Barras de Vida
	_draw_health_bar(Rect2(hero_x - 55, 18, 110, 10), hero_hp_ratio, Color("48c774"))
	_draw_health_bar(Rect2(enemy_x - 55, 18, 110, 10), enemy_hp_ratio, Color("f14668"))

	if loot_flash > 0.0:
		var r := 9.0 + loot_flash * 4.0
		draw_circle(Vector2(s.x * 0.50, ground_y - 16), r, Color("ffdd57", 0.50 + loot_flash * 0.40))

func _draw_health_bar(rect: Rect2, ratio: float, fill_color: Color) -> void:
	draw_rect(rect, Color("20232a"), true)
	var clamped := clampf(ratio, 0.0, 1.0)
	draw_rect(Rect2(rect.position, Vector2(rect.size.x * clamped, rect.size.y)), fill_color, true)
