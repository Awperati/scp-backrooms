extends Node

# Main game controller that manages game flow and state for 2D version
var current_level = 0
var game_state = "title"  # title, playing, paused, game_over, victory
var sanity_level = 100.0
var data_drives_collected = 0
var total_data_drives = 0
var player: Node2D
var entity_manager: Node2D
var level_manager: Node2D
var ui_manager: Node2D

signal game_started
signal game_paused
signal game_resumed
signal game_over
signal victory
signal sanity_changed
signal drives_collected

func _ready():
	# Initialize game controller
	print("Game controller initialized")
	
	# Setup signals
	connect("sanity_changed", self, "_on_sanity_changed")
	connect("drives_collected", self, "_on_drives_collected")

func start_game():
	# Start the game
	game_state = "playing"
	emit_signal("game_started")
	
	# Load first level
	load_level(0)
	
	# Show game UI
	if ui_manager:
		ui_manager.show_game_ui()

func pause_game():
	# Pause the game
	game_state = "paused"
	emit_signal("game_paused")

func resume_game():
	# Resume the game
	game_state = "playing"
	emit_signal("game_resumed")

func lose_sanity(amount: float):
	# Reduce sanity level
	sanity_level = max(0.0, sanity_level - amount)
	emit_signal("sanity_changed", sanity_level)
	
	# Check if game over
	if sanity_level <= 0:
		game_over()

func gain_sanity(amount: float):
	# Increase sanity level
	sanity_level = min(100.0, sanity_level + amount)
	emit_signal("sanity_changed", sanity_level)

func collect_data_drive():
	# Collect a data drive
	data_drives_collected += 1
	emit_signal("drives_collected", data_drives_collected)
	
	# Check if level can be completed
	if level_manager:
		level_manager.check_level_completion()

func load_level(level_index: int):
	# Load a specific level
	current_level = level_index
	
	# Load level scene
	var level_scene = preload("res://scenes/level_0.tscn")
	if level_scene:
		var level_instance = level_scene.instantiate()
		add_child(level_instance)
		
		# Store references to level components
		level_manager = level_instance
		level_manager.level_name = "Level %d" % level_index
		level_manager.required_drives = 2  # For Level 0
		
		# Setup entities in level
		if entity_manager:
			entity_manager.spawn_entities(level_index)
	
	# Update UI
	if ui_manager:
		ui_manager.update_level_info("Level %d" % level_index, 2)

func game_over():
	# End the game
	game_state = "game_over"
	emit_signal("game_over")
	
	# Show game over screen
	if ui_manager:
		ui_manager.show_game_over_screen()

func victory():
	# Player wins
	game_state = "victory"
	emit_signal("victory")
	
	# Show victory screen
	if ui_manager:
		ui_manager.show_victory_screen()

func _on_sanity_changed(new_sanity: float):
	# Handle sanity change
	if ui_manager:
		ui_manager.update_sanity_bar(new_sanity)

func _on_drives_collected(new_count: int):
	# Handle drive collection
	if ui_manager:
		ui_manager.update_drives_collected(new_count)