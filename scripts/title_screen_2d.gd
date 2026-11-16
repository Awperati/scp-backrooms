extends Node2D

# Title screen for 2D version
func _ready():
	# Setup signals for buttons
	$StartButton.connect("pressed", self, "_on_start_pressed")
	$QuitButton.connect("pressed", self, "_on_quit_pressed")

func _on_start_pressed():
	# Start the game
	get_tree().change_scene_to_file("res://scenes/game_2d.tscn")

func _on_quit_pressed():
	# Quit the game
	get_tree().quit()