extends Node

# Entity spawner for the active 2D flow.
# Spawns entities at random positions inside the level, capped at max_entities.
# Uses the 2D entity scenes (entity_2d_*.tscn) and hands each one the player
# so it can chase and attack. Destroyed entities free a slot so the level can
# refill up to the cap.

# The 5 entity types and the 2D scene each one uses.
var entity_types = ["smiler", "hound", "stalker", "watcher", "whisperer"]
var entity_scenes = {
	"smiler": "res://scenes/entities/entity_2d_smiler.tscn",
	"hound": "res://scenes/entities/entity_2d_hound.tscn",
	"stalker": "res://scenes/entities/entity_2d_stalker.tscn",
	"watcher": "res://scenes/entities/entity_2d_watcher.tscn",
	"whisperer": "res://scenes/entities/entity_2d_whisperer.tscn",
}

# Maximum number of entities alive at once.
@export var max_entities: int = 10
# Half-size of the square area entities spawn in (centered on the level origin).
@export var spawn_area: float = 10.0

var current_player: Node2D = null
var _spawned: Array = []

signal entity_spawned(entity)
signal entities_spawned(count)

# Give the spawner the player so every entity knows who to chase and attack.
func set_player(p: Node2D):
	current_player = p
	for entity in _spawned:
		entity.set_player(p)

# Spawn a single entity of the given type at a random position.
# Returns the entity, or null if the cap is reached or the type is unknown.
func spawn_entity(entity_type: String, position: Vector2 = Vector2.ZERO):
	if _spawned.size() >= max_entities:
		return null
	var path = entity_scenes.get(entity_type)
	if path == null:
		return null
	var entity = load(path).instantiate()
	if current_player:
		entity.set_player(current_player)
	add_child(entity)
	entity.position = position
	_spawned.append(entity)
	entity.entity_destroyed.connect(_on_entity_destroyed)
	entity_spawned.emit(entity)
	return entity

# Spawn one random entity type at a random position inside the spawn area.
func spawn_random_entity() -> Node2D:
	var type = entity_types[randi() % entity_types.size()]
	return spawn_entity(type, _random_position())

# Fill up to max_entities with random entities at random positions.
func spawn_random_entities(count: int):
	var n = mini(count, max_entities)
	for i in range(n):
		spawn_random_entity()
	entities_spawned.emit(_spawned.size())

# A random point inside the square spawn area.
func _random_position() -> Vector2:
	return Vector2(
		randf_range(-spawn_area, spawn_area),
		randf_range(-spawn_area, spawn_area)
	)

func _on_entity_destroyed(entity: Node2D):
	_spawned.erase(entity)

# How many entities are alive right now.
func get_current_count() -> int:
	return _spawned.size()

# Remove every spawned entity (used when the level or game is torn down).
func clear():
	for entity in _spawned.duplicate():
		if is_instance_valid(entity):
			entity.queue_free()
	_spawned.clear()
