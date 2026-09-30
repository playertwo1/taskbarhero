extends Control

@onready var bastiao_48: Node2D = $Stage/Bastiao48
@onready var bastiao_96_sprite: Sprite2D = $Stage/Bastiao96
@onready var javali: Node2D = $Stage/Javali

func _ready() -> void:
	print("ArenaPreview carregada com sucesso!")

func _on_idle_pressed() -> void:
	if bastiao_48.has_method("play_idle"):
		bastiao_48.play_idle()
	if javali.has_method("play_idle"):
		javali.play_idle()

func _on_attack_pressed() -> void:
	if bastiao_48.has_method("play_attack"):
		bastiao_48.play_attack()
	if javali.has_method("play_attack"):
		javali.play_attack()

func _on_hit_pressed() -> void:
	if bastiao_48.has_method("play_hit"):
		bastiao_48.play_hit()
	if javali.has_method("play_hit"):
		javali.play_hit()
