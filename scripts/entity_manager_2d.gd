extends Node2D

# Entity manager — spawns, tracks, and updates all entities.

var entities: Array[Node2D] = []
var active_entities: Array[Node2D] = []
var entity_counts: Dictionary = {}

@export var spawn_interval: float = 1.0
var last_spawn_time: float = 0.0

var game_manager: Node2D = null
var entity_spawner: Node2D = null
var entity_interaction_system: Node2D = null

# Entity scene references — set by game manager
var entity_scenes: Dictionary = {}

signal entity_spawned(entity)
signal entity_destroyed(entity)
signal entity_added(entity)
signal entity_removed(entity)
signal all_entities_destroyed()

func _ready():
	add_to_group("entity_manager")
	entity_counts = {
		"smiler": 0, "stalker": 0, "hound": 0,
		"watcher": 0, "whisperer": 0, "floating": 0,
	}

func set_game_manager(mgr: Node2D):
	game_manager = mgr

func set_entity_spawner(spawner: Node2D):
	entity_spawner = spawner

func set_entity_interaction_system(sys: Node2D):
	entity_interaction_system = sys

func register_entity_scene(entity_type: String, scene_path: String):
	entity_scenes[entity_type] = scene_path

func _process(delta):
	last_spawn_time += delta
	if last_spawn_time >= spawn_interval and entity_spawner != null:
		entity_spawner.spawn_entities()
		last_spawn_time = 0.0

# Spawn a single entity at a given position.
func spawn_entity_at_spawn_point(spawn_point: Node2D) -> Node2D:
	var entity_type = spawn_point.get_entity_type()
	if entity_scenes.has(entity_type):
		var scene = load(entity_scenes[entity_type])
		var entity = scene.instantiate()
		entity.global_position = spawn_point.global_position
		add_child(entity)
		add_entity(entity)
		return entity
	return null

func spawn_entity_by_type(entity_type: String, pos: Vector2) -> Node2D:
	if entity_scenes.has(entity_type):
		var scene = load(entity_scenes[entity_type])
		var entity = scene.instantiate()
		entity.global_position = pos
		add_child(entity)
		add_entity(entity)
		return entity
	return null

func add_entity(entity: Node2D):
	if entity == null:
		return
	entities.append(entity)
	active_entities.append(entity)

	var etype = entity.get_entity_type()
	if entity_counts.has(etype):
		entity_counts[etype] += 1

	entity.set_game_manager(game_manager)
	entity.set_entity_manager(self)
	entity.set_entity_interaction_system(entity_interaction_system)
	if game_manager != null and game_manager.has_method("get_player"):
		entity.set_player(game_manager.get_player())

	entity.entity_destroyed.connect(_on_entity_destroyed.bind(entity))
	entity_added.emit(entity)

func _on_entity_destroyed(_entity, entity: Node2D):
	entities.erase(entity)
	active_entities.erase(entity)
	var etype = entity.get_entity_type()
	if entity_counts.has(etype) and entity_counts[etype] > 0:
		entity_counts[etype] -= 1
	entity_removed.emit(entity)
	if entities.size() == 0:
		all_entities_destroyed.emit()

func remove_entity(entity: Node2D):
	entities.erase(entity)
	active_entities.erase(entity)
	var etype = entity.get_entity_type()
	if entity_counts.has(etype) and entity_counts[etype] > 0:
		entity_counts[etype] -= 1
	entity_removed.emit(entity)

func get_entities() -> Array[Node2D]:
	return entities

func get_active_entities() -> Array[Node2D]:
	return active_entities

func get_entity_count() -> int:
	return entities.size()

func get_entity_count_by_type(etype: String) -> int:
	return entity_counts.get(etype, 0)

func get_entity_by_type(etype: String) -> Array[Node2D]:
	var result: Array[Node2D] = []
	for e in entities:
		if e.get_entity_type() == etype:
			result.append(e)
	return result

func get_nearest_entity(pos: Vector2) -> Node2D:
	var nearest = null
	var nearest_dist = INF
	for e in entities:
		var d = e.global_position.distance_to(pos)
		if d < nearest_dist:
			nearest_dist = d
			nearest = e
	return nearest

func get_entities_in_range(pos: Vector2, range_: float) -> Array[Node2D]:
	var result: Array[Node2D] = []
	for e in entities:
		if e.global_position.distance_to(pos) <= range_:
			result.append(e)
	return result

func clear_all():
	for e in entities.duplicate():
		if is_instance_valid(e):
			e.queue_free()
	entities.clear()
	active_entities.clear()
	for key in entity_counts:
		entity_counts[key] = 0
