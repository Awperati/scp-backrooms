## Data drive collectible item
extends Node3D

# Data drive properties
@export var drive_id: String = "drive_001"
@export var is_collected: bool = false

# References to game components
var game_controller: Node
var player: Node3D

func _ready() -> void:
	# Get references to game controller
	game_controller = get_tree().get_first_node_in_group("game_controller")
	
	# Get player reference
	player = get_tree().get_first_node_in_group("player")

func _on_body_entered(body: Node) -> void:
	# Handle player collecting the data drive
	if body.name == "Player" and not is_collected:
		# Collect the data drive
		is_collected = true
		emit_signal("drive_collected", self)
		
		# Remove the drive from the scene
		queue_free()

func _on_drive_collected(drive: Node) -> void:
	# Handle drive collection
	if game_controller:
		game_controller.collect_data_drive()

# Signals
signal drive_collected