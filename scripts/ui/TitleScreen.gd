extends Control

signal start_game_requested

@onready var prompt_label: Label = $VBoxContainer/PromptLabel
@onready var touch_button: Button = $TouchButton

var _pulse_timer: float = 0.0
var _starting: bool = false

func _ready() -> void:
	if touch_button:
		touch_button.pressed.connect(_on_touch_button_pressed)

func _process(delta: float) -> void:
	if _starting:
		return
	_pulse_timer += delta * 3.5
	if prompt_label:
		prompt_label.modulate.a = 0.4 + 0.6 * (0.5 + 0.5 * sin(_pulse_timer))

func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		_start_game()
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_start_game()

func _on_touch_button_pressed() -> void:
	_start_game()

func _start_game() -> void:
	if _starting:
		return
	_starting = true
	start_game_requested.emit()
	
	# Transição para a tela principal de combate
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	tween.tween_callback(func():
		get_tree().change_scene_to_file("res://scenes/main/Main.tscn")
	)
