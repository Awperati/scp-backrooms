extends Control

func _ready():
	# Setup title screen
	$StartButton.connect("pressed", Callable(self, "_on_start_pressed"))
	$InstructionsLabel.visible = true

func _on_start_pressed():
	# Start the game
	get_tree().change_scene_to_file("res://scenes/game.tscn")