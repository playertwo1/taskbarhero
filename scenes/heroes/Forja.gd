extends Node2D

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_dead: bool = false

func _ready() -> void:
	if anim_sprite:
		anim_sprite.animation_finished.connect(_on_animation_finished)
		anim_sprite.play("idle")

func play_idle() -> void:
	if is_dead:
		return
	if anim_sprite and anim_sprite.animation != "idle":
		anim_sprite.play("idle")

func play_attack() -> void:
	if is_dead:
		return
	if anim_sprite:
		anim_sprite.play("attack")

func play_hit() -> void:
	if is_dead:
		return
	if anim_sprite:
		anim_sprite.play("hit")

func play_death() -> void:
	is_dead = true
	if anim_sprite:
		anim_sprite.play("death")

func reset() -> void:
	is_dead = false
	if anim_sprite:
		anim_sprite.play("idle")

func _on_animation_finished() -> void:
	if not is_dead and anim_sprite and anim_sprite.animation != "idle":
		anim_sprite.play("idle")
