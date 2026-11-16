extends Node

func _ready():
	# Setup title screen
	var start_button = $StartButton
	if start_button != null:
		start_button.connect("pressed", Callable(self, "_on_start_button_pressed"))

func _on_start_button_pressed():
	# Start the game
	emit_signal("start_game")