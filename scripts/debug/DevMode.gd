extends Node

## DevMode: Controla ferramentas internas de desenvolvimento e testes.
## Desativado estritamente em compilações de release.

var is_enabled: bool = false
var time_scale: float = 1.0
var forced_rng_seed: int = -1

func _ready() -> void:
	# DevMode ativo apenas em compilações de debug do Godot
	is_enabled = OS.is_debug_build()

func enable() -> void:
	if OS.is_debug_build():
		is_enabled = true

func disable() -> void:
	is_enabled = false
	Engine.time_scale = 1.0
	time_scale = 1.0

func set_custom_time_scale(scale: float) -> void:
	if is_enabled:
		time_scale = maxf(0.1, scale)
		Engine.time_scale = time_scale

func apply_rng_seed(seed_val: int) -> void:
	if is_enabled and seed_val >= 0:
		forced_rng_seed = seed_val
		seed(seed_val)
