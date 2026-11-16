## Main scene. Loads the game scene.
extends Node2D

func _ready() -> void:
	var game_scene = load("res://scenes/game.tscn")
	if game_scene:
		add_child(game_scene.instantiate())

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_F:
		get_viewport().set_input_as_handled()
