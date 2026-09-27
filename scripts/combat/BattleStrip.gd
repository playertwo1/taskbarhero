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
var enemy_visual: Node2D = null
var hero_visual: Node2D = null

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
		var s := 2.5 if enemy_is_boss else 2.0
		enemy_visual.scale = Vector2(s, s)
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
	# Background AMOLED do Bosque de Lúmen
	draw_rect(Rect2(Vector2.ZERO, s), Color("060807"), true)
	draw_line(Vector2(0, 1), Vector2(s.x, 1), Color("17231c"), 2.0)

	# Silhuetas de árvores distantes (Bosque de Lúmen)
	var bg_tree_color := Color("0b1612")
	var mid_tree_color := Color("11221b")
	for tx in [20, 80, 140, 210, 280, 350, 410]:
		# Tronco
		draw_rect(Rect2(tx, 40, 8, s.y - 82), bg_tree_color, true)
		# Copa estilizada
		var pts := PackedVector2Array([
			Vector2(tx + 4, 18),
			Vector2(tx - 18, 75),
			Vector2(tx + 26, 75)
		])
		draw_colored_polygon(pts, mid_tree_color)

	# Orbes flutuantes de Lúmen cintilante
	var lumen_orb_color := Color("38d9a9", 0.40)
	draw_circle(Vector2(s.x * 0.18, 55), 3.5, lumen_orb_color)
	draw_circle(Vector2(s.x * 0.52, 38), 2.5, lumen_orb_color)
	draw_circle(Vector2(s.x * 0.82, 65), 4.0, lumen_orb_color)

	# Ground / Solo musgoso
	var ground_y := s.y - 42.0
	draw_rect(Rect2(0, ground_y, s.x, 42), Color("101814"), true)
	draw_line(Vector2(0, ground_y), Vector2(s.x, ground_y), Color("2b4235"), 2.0)
	for x in range(0, int(s.x), 28):
		draw_line(Vector2(x, ground_y + 8), Vector2(x + 12, ground_y + 4), Color("1e3025"), 2.0)

	# Hero: Bastião (Guardião com espada e escudo)
	var hero_x := s.x * 0.25
	var hero_y := ground_y - 42.0
	if hero_visual and is_instance_valid(hero_visual) and hero_visual.visible:
		# Nó filho Bastiao cuida da renderização das animações
		pass
	else:
		var hero_color := Color("4dabf7").lerp(Color.WHITE, hero_attack_flash * 0.70)
		var shield_color := Color("339af0").lerp(Color.WHITE, hero_attack_flash * 0.50)
		# Corpo e Elmo
		draw_circle(Vector2(hero_x, hero_y - 30), 16, hero_color)
		draw_rect(Rect2(hero_x - 14, hero_y - 14, 28, 42), hero_color, true)
		# Escudo frontal de Bastião
		draw_rect(Rect2(hero_x + 8, hero_y - 8, 12, 32), shield_color, true)
		# Espada
		draw_line(Vector2(hero_x + 16, hero_y - 2), Vector2(hero_x + 36, hero_y - 22), Color("e9ecef"), 4.0)

	# Inimigo
	var enemy_x := s.x * 0.73
	var enemy_scale := 1.25 if enemy_is_boss else 1.0
	if enemy_visual and is_instance_valid(enemy_visual) and enemy_visual.visible:
		# Nó filho GeleiaDeLumen cuida da renderização das animações
		pass
	else:
		var enemy_color := Color("ff5c5c").lerp(Color.WHITE, enemy_attack_flash * 0.60)
		draw_circle(Vector2(enemy_x, hero_y - 19.0 * enemy_scale), 26.0 * enemy_scale, enemy_color)
		draw_circle(Vector2(enemy_x - 9.0 * enemy_scale, hero_y - 24.0 * enemy_scale), 3.0 * enemy_scale, Color("0d0e12"))
		draw_circle(Vector2(enemy_x + 9.0 * enemy_scale, hero_y - 24.0 * enemy_scale), 3.0 * enemy_scale, Color("0d0e12"))

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
