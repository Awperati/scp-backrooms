## Exit door that leads to next level
extends Node3D

# Door properties
@export var required_drives: int = 3
@export var is_unlocked: bool = false
@export var door_id: String = "exit_door_001"

# References to game components
var game_controller: Node
var player: Node3D

func _ready() -> void:
	# Get references to game controller
	game_controller = get_tree().get_first_node_in_group("game_controller")
	
	# Get player reference
	player = get_tree().get_first_node_in_group("player")

func _on_body_entered(body: Node) -> void:
	# Handle player approaching the door
	if body.name == "Player":
		# Check if player can pass through
		if is_unlocked:
			# Unlock door and allow passage
			emit_signal("door_unlocked", self)
		else:
			# Door is locked, notify player
			emit_signal("door_locked", self)

func unlock_door() -> void:
	# Unlock the door
	is_unlocked = true

func lock_door() -> void:
	# Lock the door
	is_unlocked = false

func _on_door_unlocked(door: Node) -> void:
	# Handle door unlock
	pass

func _on_door_locked(door: Node) -> void:
	# Handle door lock
	pass

# Signals
signal door_unlocked
signal door_locked