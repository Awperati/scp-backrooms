extends Node

# Spawning configuration
@export var spawn_rate: float = 5.0  # seconds between spawns
@export var max_entities: int = 10
@export var spawn_radius: float = 10.0

# Internal variables
var spawn_timer: float = 0.0
var game_controller: Node = null

# Entity types and their prefabs
var entity_prefabs = {
	"SMILER": preload("res://scenes/entities/entity_smiler.tscn"),
	"HOUND": preload("res://scenes/entities/entity_hound.tscn"),
	"STALKER": preload("res://scenes/entities/entity_stalker.tscn"),
	"WATCHER": preload("res://scenes/entities/entity_watcher.tscn"),
	"WHISPERER": preload("res://scenes/entities/entity_whisperer.tscn")
}

func initialize():
	game_controller = get_tree().get_nodes_in_group("game_controller")[0] if get_tree().get_nodes_in_group("game_controller").size() > 0 else null

func update(delta):
	if game_controller == null:
		return
		
	if game_controller.game_state != "PLAYING":
		return
		
	spawn_timer += delta
	if spawn_timer >= spawn_rate and entities.size() < max_entities:
		spawn_entity()
		spawn_timer = 0.0

func spawn_entity():
	var entity_type = get_random_entity_type()
	var entity_scene = entity_prefabs[entity_type]
	
	if entity_scene != null:
		var entity_instance = entity_scene.instantiate()
		entity_instance.position = get_spawn_position()
		entity_instance.entity_type = entity_type
		
		# Add to scene
		add_child(entity_instance)
		
		# Add to game controller
		if game_controller != null:
			game_controller.add_entity(entity_instance)

func get_random_entity_type():
	var types = entity_prefabs.keys()
	return types[randi() % types.size()]

func get_spawn_position():
	# Spawn at a random position within spawn radius
	var angle = randf() * 2 * PI
	var radius = randf() * spawn_radius
	var x = cos(angle) * radius
	var z = sin(angle) * radius
	return Vector3(x, 0, z)