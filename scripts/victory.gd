extends Control

func _ready():
	# Setup victory screen
	$ExitButton.connect("pressed", Callable(self, "_on_exit_pressed"))
	$MainMenuButton.connect("pressed", Callable(self, "_on_main_menu_pressed"))

func _on_exit_pressed():
	# Exit the game
	get_tree().quit()

func _on_main_menu_pressed():
	# Go back to main menu
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")