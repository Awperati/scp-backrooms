extends Control

func _ready():
	# Setup game over screen
	$RestartButton.connect("pressed", Callable(self, "_on_restart_pressed"))
	$MainMenuButton.connect("pressed", Callable(self, "_on_main_menu_pressed"))

func _on_restart_pressed():
	# Restart current level
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_main_menu_pressed():
	# Go back to main menu
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")