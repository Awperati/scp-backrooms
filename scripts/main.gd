## Main scene. Controls game flow between scenes.
extends Node

# Game scenes
var title_scene = preload("res://scenes/title_screen.tscn")
var game_scene = preload("res://scenes/game.tscn")
var game_over_scene = preload("res://scenes/game_over.tscn")
var victory_scene = preload("res://scenes/victory.tscn")

# Current scene reference
var current_scene = null

func _ready() -> void:
	# Load the title screen by default
	load_scene("title")

func load_scene(scene_name: String):
	# Remove current scene if exists
	if current_scene:
		current_scene.queue_free()
		current_scene = null
	
	# Load new scene
	var scene
	match scene_name:
		"title":
			scene = title_scene.instantiate()
		"game":
			scene = game_scene.instantiate()
		"game_over":
			scene = game_over_scene.instantiate()
		"victory":
			scene = victory_scene.instantiate()
		_:
			return
	
	# Add to scene
	add_child(scene)
	current_scene = scene

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_F:
		get_viewport().set_input_as_handled()