extends Node

func _ready():
	# Setup game over screen
	var restart_button = $RestartButton
	if restart_button != null:
		restart_button.connect("pressed", Callable(self, "_on_restart_button_pressed"))

func _on_restart_button_pressed():
	# Restart the game
	TransitionManager.change_scene("res://scenes/levels/level_0.tscn")