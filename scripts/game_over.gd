extends Node

signal restart_game

func _ready():
	# Setup game over screen
	var restart_button = $RestartButton
	if restart_button != null:
		restart_button.connect("pressed", Callable(self, "_on_restart_button_pressed"))

func _on_restart_button_pressed():
	# Restart the game
	emit_signal("restart_game")
