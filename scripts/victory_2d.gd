extends Node2D

# Victory screen for 2D version
func _ready():
	# Setup signals for buttons
	$ContinueButton.connect("pressed", self, "_on_continue_pressed")
	$MainMenuButton.connect("pressed", self, "_on_main_menu_pressed")

func _on_continue_pressed():
	# Continue to next level or restart
	get_tree().change_scene_to_file("res://scenes/game_2d.tscn")

func _on_main_menu_pressed():
	# Go to main menu
	get_tree().change_scene_to_file("res://scenes/main.tscn")