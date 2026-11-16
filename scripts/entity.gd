## Base entity class for all game entities
extends Node3D

# Entity properties
@export var entity_type: String = "ANOMALOUS"
@export var health: int = 100
@export var max_health: int = 100
@export var speed: float = 1.0
@export var detection_range: float = 5.0
@export var attack_range: float = 1.0
@export var damage: int = 10
@export var is_alive: bool = true

# References to game components
var game_controller: Node
var player: Node3D
var entity_manager: Node

# AI state
var current_state: String = "IDLE"

# Movement
var target_position: Vector3
var velocity: Vector3 = Vector3.ZERO

func _ready() -> void:
	# Get references to game controller
	game_controller = get_tree().get_first_node_in_group("game_controller")
	
	# Get player reference
	player = get_tree().get_first_node_in_group("player")
	
	# Get entity manager
	entity_manager = get_tree().get_first_node_in_group("entity_manager")
	
	# Setup AI
	setup_ai()

func setup_ai() -> void:
	# Setup basic AI behavior
	pass

func _process(delta: float) -> void:
	# Update AI behavior
	if is_alive:
		update_ai(delta)

func update_ai(delta: float) -> void:
	# Update AI state
	pass

func take_damage(damage_amount: int) -> void:
	# Take damage from player or environment
	health -= damage_amount
	if health <= 0:
		die()

func die() -> void:
	# Entity dies
	is_alive = false
	emit_signal("entity_destroyed", self)
	queue_free()

func _on_entity_destroyed(entity: Node) -> void:
	# Handle entity destruction
	if entity == self:
		queue_free()

func _on_player_detected(player: Node3D) -> void:
	# Handle player detection
	pass

func _on_player_attacked(player: Node3D) -> void:
	# Handle player attack
	pass

func _on_player_in_range(player: Node3D) -> void:
	# Handle player in range
	pass

# Signals
signal entity_destroyed
signal player_detected
signal player_attacked
signal player_in_range