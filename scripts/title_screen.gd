## Title screen. Shows start button, fades into game.
extends Control

var fade_timer: float = 0.0
var fade_duration: float = 2.0
var is_fading: bool = false

func _ready() -> void:
	$VBoxContainer/StartButton.pressed.connect(_on_start_button_pressed)
	$VBoxContainer/Instructions.text = "WASD: Move | Shift: Sprint | Space: Jump | F: Flashlight"
	$VBoxContainer/Subtitle.text = "An Escape Horror"

func _on_start_button_pressed() -> void:
	is_fading = true
	fade_timer = 0.0

func _process(delta: float) -> void:
	if is_fading:
		fade_timer += delta
		var t = fade_timer / fade_duration
		var alpha = 1.0 - t
		modulate = Color(1, 1, 1, alpha)
		if fade_timer >= fade_duration:
			var game_scene = load("res://scenes/game.tscn")
			var game = game_scene.instantiate()
			get_tree().root.add_child(game)
			queue_free()