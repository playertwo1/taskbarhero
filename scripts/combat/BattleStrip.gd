extends Control

var hero_hp_ratio: float = 1.0
var enemy_hp_ratio: float = 1.0
var enemy_is_boss: bool = false
var hero_attack_flash: float = 0.0
var enemy_attack_flash: float = 0.0
var loot_flash: float = 0.0
var enemy_name: String = "Inimigo"
var current_enemy_id: String = ""

const SLIME_SCENE = preload("res://scenes/enemies/GeleiaDeLumen.tscn")
var enemy_visual: Node2D = null

func _ready() -> void:
	custom_minimum_size = Vector2(0, 220)
	set_process(true)

func _process(delta: float) -> void:
	hero_attack_flash = maxf(0.0, hero_attack_flash - delta * 4.0)
	enemy_attack_flash = maxf(0.0, enemy_attack_flash - delta * 4.0)
	loot_flash = maxf(0.0, loot_flash - delta * 2.0)
	
	if enemy_visual and is_instance_valid(enemy_visual) and enemy_visual.visible:
		var ground_y := size.y - 42.0
		var enemy_x := size.x * 0.73
		enemy_visual.position = Vector2(enemy_x, ground_y)
		
	queue_redraw()

func set_enemy(enemy_data: Dictionary) -> void:
	current_enemy_id = enemy_data.get("id", "")
	enemy_name = enemy_data.get("name", "Inimigo")
	enemy_is_boss = enemy_data.get("boss", false)
	
	if current_enemy_id == "geleia_de_lumen":
		if enemy_visual == null or not is_instance_valid(enemy_visual):
			enemy_visual = SLIME_SCENE.instantiate()
			add_child(enemy_visual)
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
	if enemy_visual and is_instance_valid(enemy_visual) and enemy_visual.visible:
		if enemy_visual.has_method("play_hit"):
			enemy_visual.play_hit()

func flash_enemy_attack() -> void:
	enemy_attack_flash = 1.0
	if enemy_visual and is_instance_valid(enemy_visual) and enemy_visual.visible:
		if enemy_visual.has_method("play_attack"):
			enemy_visual.play_attack()

func play_enemy_death() -> void:
	if enemy_visual and is_instance_valid(enemy_visual) and enemy_visual.visible:
		if enemy_visual.has_method("play_death"):
			enemy_visual.play_death()

func flash_loot() -> void:
	loot_flash = 1.0

func _draw() -> void:
	var s := size
	# Background AMOLED
	draw_rect(Rect2(Vector2.ZERO, s), Color("0d0e12"), true)
	draw_line(Vector2(0, 1), Vector2(s.x, 1), Color("22252c"), 2.0)

	# Ground / Faixa de batalha
	var ground_y := s.y - 42.0
	draw_rect(Rect2(0, ground_y, s.x, 42), Color("141816"), true)
	for x in range(0, int(s.x), 36):
		draw_line(Vector2(x, ground_y + 10), Vector2(x + 14, ground_y + 6), Color("202a24"), 2.0)

	# Hero placeholder (substituído por sprites reais nos marcos seguintes)
	var hero_x := s.x * 0.25
	var hero_y := ground_y - 42.0
	var hero_color := Color("4db8ff").lerp(Color.WHITE, hero_attack_flash * 0.70)
	draw_circle(Vector2(hero_x, hero_y - 30), 18, hero_color)
	draw_rect(Rect2(hero_x - 16, hero_y - 12, 32, 42), hero_color, true)
	draw_line(Vector2(hero_x + 14, hero_y - 3), Vector2(hero_x + 38, hero_y - 24), Color("e0e4ec"), 5.0)

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
