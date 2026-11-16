## Victory screen. Shows when player escapes all levels.
extends Control

var fade_timer: float = 0.0
var fade_duration: float = 2.0
var is_fading: bool = false

func _ready() -> void:
	$VBoxContainer/MenuButton.pressed.connect(_on_menu_button_pressed)
	$VBoxContainer/Subtitle.text = "You escaped the Backrooms."

func _on_menu_button_pressed() -> void:
	is_fading = true
	fade_timer = 0.0

func _process(delta: float) -> void:
	if is_fading:
		fade_timer += delta
		var t = fade_timer / fade_duration
		var alpha = 1.0 - t
		modulate = Color(1, 1, 1, alpha)
		if fade_timer >= fade_duration:
			get_tree().reload_current_scene()