extends Node

signal restart_game

func _ready():
	# Setup victory screen
	var exit_button = $ExitButton
	if exit_button != null:
		exit_button.connect("pressed", Callable(self, "_on_exit_button_pressed"))

	var main_menu_button = $MainMenuButton
	if main_menu_button != null:
		main_menu_button.connect("pressed", Callable(self, "_on_main_menu_button_pressed"))

func _on_exit_button_pressed():
	# Exit the game
	get_tree().quit()

func _on_main_menu_button_pressed():
	# Go to main menu (title screen)
	emit_signal("restart_game")
