## Manages all entities in the game
extends Node

# Entity types
enum EntityType {
	ANOMALOUS,
	DESTRUCTIVE,
	ITEM,
	DOOR
}

# Entity states
enum EntityState {
	IDLE,
	ALERT,
	CHASE,
	ATTACK,
	RETREAT
}

# References to game components
var game_controller: Node
var player: Node3D
var level_manager: Node

# Spawn configuration
var spawn_rates: Dictionary = {
	0: { # Level 0
		"smiler": 2,
		"hound": 1,
		"stalker": 1,
		"watcher": 0,
		"whisperer": 0
	}
}

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
	# Start spawning entities when game starts
	_spawn_entities_for_level(0)

func _on_game_over() -> void:
	# Stop spawning when game is over
	_clear_entities()

func _on_victory() -> void:
	# Clear entities on victory
	_clear_entities()

func spawn_entities(level_index: int) -> void:
	# Spawn entities for a specific level
	_spawn_entities_for_level(level_index)

func _spawn_entities_for_level(level_index: int) -> void:
	# Get spawn configuration for level
	if not spawn_rates.has(level_index):
		return
	
	var level_spawns = spawn_rates[level_index]
	
	# Spawn each type of entity
	for entity_type in level_spawns.keys():
		var count = level_spawns[entity_type]
		
		# Spawn the entity instances
		for i in range(count):
			var entity_scene = preload("res://scenes/entities/entity_%s.tscn" % entity_type)
			var entity_instance = entity_scene.instantiate()
			
			# Position the entity in a random location
			var position = Vector3(
				randf_range(-10.0, 10.0),
				0.0,
				randf_range(-10.0, 10.0)
			)
			entity_instance.global_position = position
			
			# Add to scene
			add_child(entity_instance)

func _clear_entities() -> void:
	# Clear all entities from the scene
	for child in get_children():
		if child.name != "GameController":
			child.queue_free()

func _on_entity_destroyed(entity: Node) -> void:
	# Handle entity destruction
	if entity in get_children():
		entity.queue_free()