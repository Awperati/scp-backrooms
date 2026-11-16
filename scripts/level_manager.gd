## Manages level loading and transitions
extends Node

# Level properties
@export var level_name: String = "Level 0"
@export var required_drives: int = 2
@export var level_index: int = 0

# References to game components
var game_controller: Node
var player: Node3D

func _ready() -> void:
	# Get references to game controller
	game_controller = get_tree().get_first_node_in_group("game_controller")
	
	# Get player reference
	player = get_tree().get_first_node_in_group("player")
	
	# Setup signals
	if game_controller:
		game_controller.connect("game_started", self, "_on_game_started")
		game_controller.connect("game_over", self, "_on_game_over")
		game_controller.connect("victory", self, "_on_victory")

func _on_game_started() -> void:
	# Initialize level when game starts
	print("Starting level %s" % level_name)

func _on_game_over() -> void:
	# Handle game over for this level
	print("Level %s game over" % level_name)

func _on_victory() -> void:
	# Handle victory for this level
	print("Level %s victory" % level_name)

func check_level_completion() -> void:
	# Check if level can be completed based on collected drives
	if GameController.data_drives_collected >= required_drives:
		# Level can be completed
		complete_level()

func complete_level() -> void:
	# Complete current level
	print("Level %s completed!" % level_name)
	
	# Notify game controller of level completion
	if game_controller:
		game_controller.victory()

func _on_exit_door_triggered(required_drives: int) -> void:
	# Handle exit door interaction
	if GameController.data_drives_collected >= required_drives:
		# Unlock and enter next level
		if game_controller:
			game_controller.load_level(level_index + 1)
	else:
		# Door is locked, notify player
		print("Door is locked. Collect %d data drives to proceed." % required_drives)