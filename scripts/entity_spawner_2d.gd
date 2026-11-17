extends Node2D

# Entity spawner — decides which entities to spawn and where.

var spawn_points: Array[Node2D] = []
var spawn_point_groups: Dictionary = {}

@export var current_level: int = 0
@export var max_entities_per_level: int = 10
var entities_to_spawn: int = 0

var game_manager: Node2D = null
var entity_manager: Node2D = null

signal spawn_points_loaded(spawn_points)
signal entities_spawned(entities)
signal spawn_point_added(spawn_point)
signal spawn_point_removed(spawn_point)

func _ready():
	add_to_group("entity_spawner")
	spawn_point_groups = {
		"smiler": [], "stalker": [], "hound": [],
		"watcher": [], "whisperer": [], "floating": [],
	}
	# Find spawn points in this level
	_find_spawn_points()

func _find_spawn_points():
	# Look for children with "spawn_point" in their name
	var parent = get_parent()
	if parent == null:
		return
	for child in parent.get_children():
		if child is Node2D and child.name.to_lower().contains("spawn"):
			if not spawn_points.has(child):
				add_spawn_point(child)

func set_game_manager(mgr: Node2D):
	game_manager = mgr

func set_entity_manager(mgr: Node2D):
	entity_manager = mgr

func add_spawn_point(spawn_point: Node2D):
	if spawn_point == null:
		return
	spawn_points.append(spawn_point)
	var etype = spawn_point.get_entity_type()
	if spawn_point_groups.has(etype):
		spawn_point_groups[etype].append(spawn_point)
	spawn_point_added.emit(spawn_point)

func remove_spawn_point(spawn_point: Node2D):
	spawn_points.erase(spawn_point)
	var etype = spawn_point.get_entity_type()
	if spawn_point_groups.has(etype):
		spawn_point_groups[etype].erase(spawn_point)
	spawn_point_removed.emit(spawn_point)

func spawn_entities():
	if entity_manager == null:
		return
	var to_spawn = mini(max_entities_per_level, spawn_points.size())
	if to_spawn == 0:
		return
	var spawned = []
	for i in range(to_spawn):
		var etype = _select_entity_type()
		var point = _get_random_spawn_point(etype)
		if point == null:
			point = _get_any_spawn_point()
		if point != null:
			var entity = entity_manager.spawn_entity_at_spawn_point(point)
			if entity != null:
				spawned.append(entity)
	if spawned.size() > 0:
		entities_spawned.emit(spawned)

func _select_entity_type() -> String:
	var types = ["smiler", "stalker", "hound", "watcher", "whisperer", "floating"]
	var weights = []
	match current_level:
		0: weights = [0.3, 0.25, 0.2, 0.1, 0.1, 0.05]
		1: weights = [0.2, 0.25, 0.25, 0.1, 0.1, 0.1]
		2: weights = [0.15, 0.2, 0.25, 0.15, 0.15, 0.1]
		3: weights = [0.1, 0.15, 0.25, 0.2, 0.15, 0.15]
		_: weights = [0.05, 0.15, 0.2, 0.2, 0.2, 0.2]
	var rand = randf()
	var cumulative = 0.0
	for i in range(types.size()):
		cumulative += weights[i]
		if rand <= cumulative:
			return types[i]
	return types[0]

func _get_random_spawn_point(etype: String) -> Node2D:
	var pool = spawn_point_groups.get(etype, [])
	if pool.size() == 0:
		return null
	return pool[randi() % pool.size()]

func _get_any_spawn_point() -> Node2D:
	if spawn_points.size() == 0:
		return null
	return spawn_points[randi() % spawn_points.size()]

func set_current_level(level: int):
	current_level = level

func get_current_level() -> int:
	return current_level

func get_spawn_points() -> Array[Node2D]:
	return spawn_points

func get_spawn_points_by_type(etype: String) -> Array[Node2D]:
	return spawn_point_groups.get(etype, [])

func is_active() -> bool:
	return is_inside_tree()

func set_active(active: bool):
	set_process(active)
