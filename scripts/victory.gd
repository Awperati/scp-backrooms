extends Node

func _ready():
	# Setup victory screen
	var main_menu_button = $MainMenuButton
	if main_menu_button != null:
		main_menu_button.connect("pressed", Callable(self, "_on_main_menu_button_pressed"))

func _on_main_menu_button_pressed():
	# Go to main menu
	TransitionManager.change_scene("res://scenes/title_screen.tscn")