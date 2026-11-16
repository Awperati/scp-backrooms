extends CharacterBody3D

# Entity Base Class
# This is the base class for all entities in the SCP Backrooms Game
# It handles basic entity properties, health system, game state management
# and provides a foundation for inheritance by specific entity types

# Entity properties
@export var entity_type: String = "ANOMALOUS"
@export var health: float = 100.0
@export var max_health: float = 100.0
@export var speed: float = 1.0
@export var detection_range: float = 5.0
@export var attack_range: float = 1.0
@export var damage: float = 10.0
@export var is_active: bool = true

# Game state
var player: Node3D = null
var game_controller: Node = null
var entity_manager: Node = null
var is_alive: bool = true

# Movement
var velocity: Vector3 = Vector3.ZERO

# Damage and health system
signal health_changed(new_health, max_health)
signal entity_damaged(amount, new_health)
signal entity_killed(entity)

# Initialization
func _ready():
	# Initialize the entity
	player = get_tree().get_nodes_in_group("player")[0] if get_tree().get_nodes_in_group("player").size() > 0 else null
	game_controller = get_tree().get_nodes_in_group("game_controller")[0] if get_tree().get_nodes_in_group("game_controller").size() > 0 else null
	entity_manager = get_tree().get_nodes_in_group("entity_manager")[0] if get_tree().get_nodes_in_group("entity_manager").size() > 0 else null
	
	# Add to entity manager if available
	if entity_manager != null:
		entity_manager.add_entity(self)
	
	# Connect health changed signal
	connect("health_changed", self, "_on_health_changed")

func _process(delta):
	# Override in child classes for behavior
	pass

# Health system
func take_damage(amount: float):
	if not is_alive:
		return
	
	health -= amount
	if health <= 0:
		health = 0
		is_alive = false
		emit_signal("entity_damaged", amount, health)
		emit_signal("entity_killed", self)
		kill_entity()
	else:
		emit_signal("entity_damaged", amount, health)
		emit_signal("health_changed", health, max_health)

func heal(amount: float):
	if not is_alive:
		return
		
	health = min(health + amount, max_health)
	emit_signal("health_changed", health, max_health)

func set_health(new_health: float):
	health = clamp(new_health, 0, max_health)
	emit_signal("health_changed", health, max_health)

func get_health_percentage() -> float:
	return health / max_health

# Game state management
func set_active(active: bool):
	is_active = active

func get_active() -> bool:
	return is_active

# Entity lifecycle
func kill_entity():
	if not is_alive:
		return
	
	is_alive = false
	
	# Remove entity from game
	if entity_manager != null:
		entity_manager.remove_entity(self)
	
	# Remove from scene
	queue_free()

# Utility methods
func get_distance_to_player() -> float:
	if player == null:
		return INFINITY
	return position.distance_to(player.position)

func is_player_in_range(range: float) -> bool:
	if player == null:
		return false
	return position.distance_to(player.position) <= range

func set_entity_type(type: String):
	entity_type = type

func get_entity_type() -> String:
	return entity_type

func get_entity_info() -> Dictionary:
	return {
		"type": entity_type,
		"health": health,
		"max_health": max_health,
		"speed": speed,
		"detection_range": detection_range,
		"attack_range": attack_range,
		"damage": damage,
		"is_active": is_active,
		"is_alive": is_alive
	}

# Callbacks for child classes to override
func _on_health_changed(new_health: float, max_health: float):
	# Override in child classes to handle health changes
	pass

func _on_entity_damaged(amount: float, new_health: float):
	# Override in child classes to handle damage
	pass

func _on_entity_killed(entity):
	# Override in child classes to handle death
	pass