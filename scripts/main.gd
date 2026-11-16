## Main scene controller for game initialization
extends Node

# Scene references
var game_controller: Node
var player: Node3D
var entity_manager: Node
var entity_spawner: Node
var audio_manager: Node
var sanity_system: Node

func _ready() -> void:
	# Initialize the game
	setup_game()

func setup_game() -> void:
	# Get references to all game components
	game_controller = get_node("GameController")
	player = get_node("Player")
	entity_manager = get_node("EntityManager")
	entity_spawner = get_node("EntitySpawner")
	audio_manager = get_node("AudioManager")
	sanity_system = get_node("SanitySystem")
	
	# Connect signals
	setup_signals()

func setup_signals() -> void:
	# Connect game controller signals
	if game_controller:
		game_controller.connect("game_started", self, "_on_game_started")
		game_controller.connect("game_over", self, "_on_game_over")
		game_controller.connect("victory", self, "_on_victory")
		game_controller.connect("data_drive_collected", self, "_on_data_drive_collected")
		game_controller.connect("sanity_changed", self, "_on_sanity_changed")
		game_controller.connect("player_damaged", self, "_on_player_damaged")

func _on_game_started() -> void:
	# Game started
	print("Game started")

func _on_game_over() -> void:
	# Game over
	print("Game over")

func _on_victory() -> void:
	# Victory
	print("Victory!")

func _on_data_drive_collected(drive: Node) -> void:
	# Data drive collected
	print("Data drive collected")

func _on_sanity_changed(new_sanity: float) -> void:
	# Sanity changed
	print("Sanity: %.2f" % new_sanity)

func _on_player_damaged(amount: int) -> void:
	# Player damaged
	print("Player damaged by %d" % amount)

func start_game() -> void:
	# Start the game
	game_controller.start_game()

func game_over() -> void:
	# End the game
	game_controller.game_over()

func victory() -> void:
	# Player wins
	game_controller.victory()

func load_level(level_index: int) -> void:
	# Load a specific level
	game_controller.load_level(level_index)

func update_sanity(change: float) -> void:
	# Update player sanity
	game_controller.update_sanity(change)