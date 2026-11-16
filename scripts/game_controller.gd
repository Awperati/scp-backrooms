## Main game controller that manages game flow and states
extends Node

# Game states
enum GameState {
	START_SCREEN,
	PLAYING,
	GAME_OVER,
	VICTORY,
	PAUSED
}

# Game variables
var current_state: GameState = GameState.START_SCREEN
var data_drives_collected: int = 0
var total_data_drives: int = 3
var player_health: int = 100
var player_sanity: float = 1.0
var level_complete: bool = false

# Signals
signal game_started
signal game_over
signal victory
signal data_drive_collected
signal sanity_changed
signal player_damaged

func _ready() -> void:
	# Initialize game controller
	_setup_game_controller()
	
	# Connect to signals
	connect("game_started", self, "_on_game_started")
	connect("game_over", self, "_on_game_over")
	connect("victory", self, "_on_victory")

func _setup_game_controller() -> void:
	# Initialize game settings
	data_drives_collected = 0
	player_health = 100
	player_sanity = 1.0
	level_complete = false

func start_game() -> void:
	# Start the game
	current_state = GameState.PLAYING
	emit_signal("game_started")
	print("Game started")

func game_over() -> void:
	# End the game
	current_state = GameState.GAME_OVER
	emit_signal("game_over")
	print("Game over")

func victory() -> void:
	# Player wins
	current_state = GameState.VICTORY
	emit_signal("victory")
	print("Victory!")

func collect_data_drive() -> void:
	# Collect a data drive
	data_drives_collected += 1
	emit_signal("data_drive_collected")
	
	# Check if all drives collected
	if data_drives_collected >= total_data_drives:
		level_complete = true
		print("All data drives collected!")

func update_sanity(change: float) -> void:
	# Update player sanity
	player_sanity += change
	player_sanity = clamp(player_sanity, 0.0, 1.0)
	emit_signal("sanity_changed")

func damage_player(amount: int) -> void:
	# Damage the player
	player_health -= amount
	emit_signal("player_damaged")
	
	# Check if player is dead
	if player_health <= 0:
		player_health = 0
		game_over()

func load_level(level_index: int) -> void:
	# Load a specific level
	print("Loading level %d" % level_index)
	
	# Clear current level
	get_tree().call_group("entities", "queue_free")
	
	# Load new level
	# This would typically involve loading a new scene
	# For now, just reset the game state
	_setup_game_controller()
	
	# Start new level
	start_game()

func _on_game_started() -> void:
	# Handle game started event
	print("Game started event received")

func _on_game_over() -> void:
	# Handle game over event
	print("Game over event received")

func _on_victory() -> void:
	# Handle victory event
	print("Victory event received")