## Spawns entities in the game world
extends Node

# Spawn configuration
@export var spawn_interval: float = 5.0
@export var max_entities: int = 10

# References to game components
var game_controller: Node
var player: Node3D
var entity_manager: Node

# Spawn timer
var spawn_timer: float = 0.0
var entities_spawned: int = 0

# Entity types and their spawn weights
var entity_weights: Dictionary = {
	"smiler": 30,
	"hound": 25,
	"stalker": 20,
	"watcher": 15,
	"whisperer": 10
}

func _ready() -> void:
	# Get references to game controller
	game_controller = get_tree().get_first_node_in_group("game_controller")
	
	# Get player reference
	player = get_tree().get_first_node_in_group("player")
	
	# Get entity manager
	entity_manager = get_tree().get_first_node_in_group("entity_manager")
	
	# Setup signals
	if game_controller:
		game_controller.connect("game_started", self, "_on_game_started")
		game_controller.connect("game_over", self, "_on_game_over")
		game_controller.connect("victory", self, "_on_victory")

func _process(delta: float) -> void:
	# Update spawn timer
	if game_controller.current_state == GameController.GameState.PLAYING:
		spawn_timer += delta
		
		# Check if it's time to spawn a new entity
		if spawn_timer >= spawn_interval and entities_spawned < max_entities:
			spawn_entity()
			spawn_timer = 0.0

func _on_game_started() -> void:
	# Start spawning when game starts
	spawn_timer = 0.0

func _on_game_over() -> void:
	# Stop spawning when game is over
	pass

func _on_victory() -> void:
	# Stop spawning when player wins
	pass

func spawn_entity() -> void:
	# Choose a random entity type based on weights
	var entity_type = _choose_entity_type()
	
	# Get the entity scene
	var entity_scene = preload("res://scenes/entities/entity_%s.tscn" % entity_type)
	
	# Instantiate the entity
	var entity_instance = entity_scene.instantiate()
	
	# Position the entity in a random location near the player
	var spawn_distance = randf_range(5.0, 10.0)
	var angle = randf_range(0, 2 * PI)
	
	var position = Vector3(
		player.global_position.x + sin(angle) * spawn_distance,
		player.global_position.y,
		player.global_position.z + cos(angle) * spawn_distance
	)
	
	entity_instance.global_position = position
	
	# Add to scene
	add_child(entity_instance)
	
	# Update entity count
	entities_spawned += 1
	
	# Connect to entity destruction signal
	entity_instance.connect("entity_destroyed", self, "_on_entity_destroyed")

func _choose_entity_type() -> String:
	# Choose an entity type based on weights
	var total_weight = 0
	for weight in entity_weights.values():
		total_weight += weight
	
	var random_weight = randi() % total_weight
	
	var current_weight = 0
	for entity_type in entity_weights.keys():
		current_weight += entity_weights[entity_type]
		if random_weight < current_weight:
			return entity_type
	
	# Default fallback
	return "smiler"

func _on_entity_destroyed(entity: Node) -> void:
	# Handle entity destruction
	if entity in get_children():
		entity.queue_free()
		entities_spawned -= 1