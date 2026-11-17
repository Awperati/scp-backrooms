extends Node3D

# 3D level manager — loads/unloads level scenes, spawns entities, places the player.

@export var level_scene_path: String = "res://scenes/levels/level_0.tscn"
@export var player_spawn_group: String = "player"
@export var spawn_point_group: String = "spawn_point"
@export var entity_spawner_group: String = "entity_spawner"

var current_level: Node = null
var player: Node = null
var game_manager: Node = null

signal level_loaded(level)
signal level_unloaded(level)
signal level_transition_started(from_level, to_level)
signal level_transition_completed(level)
signal player_placed(spawn_point)
signal entities_spawned(entities)

func _ready():
	add_to_group("level_manager")
	game_manager = get_node_or_null("/root/GameManager")
	if game_manager == null:
		game_manager = get_node_or_null("/root/GameController")
	load_level()

# --- Level transitions ---

func load_level(scene_path: String = "") -> Node:
	if scene_path == "":
		scene_path = level_scene_path
	unload_level()
	var scene: PackedScene = load(scene_path)
	if scene == null:
		push_error("level_manager: could not load scene " + scene_path)
		return null
	current_level = scene.instantiate()
	add_child(current_level)
	level_transition_started.emit(null, current_level)
	_place_player()
	_spawn_entities()
	level_loaded.emit(current_level)
	level_transition_completed.emit(current_level)
	return current_level

func unload_level():
	if current_level == null:
		return
	level_unloaded.emit(current_level)
	current_level.queue_free()
	current_level = null

# --- Player placement ---

func _place_player():
	player = get_tree().get_first_node_in_group(player_spawn_group)
	if player == null:
		return
	var spawn = _find_spawn_point()
	if spawn == null:
		return
	# 3D player at a 2D spawn point (or vice versa): convert the position.
	if player is Node3D and spawn is Node2D:
		player.global_position = Vector3(spawn.global_position.x, spawn.global_position.y, 0)
	elif player is Node2D and spawn is Node3D:
		player.global_position = Vector2(spawn.global_position.x, spawn.global_position.y)
	else:
		player.global_position = spawn.global_position
	player_placed.emit(spawn)

func _find_spawn_point() -> Node:
	var nodes = get_tree().get_nodes_in_group(spawn_point_group)
	if nodes.size() > 0:
		return nodes[0]
	if current_level != null and current_level.has_node("PlayerSpawn"):
		return current_level.get_node("PlayerSpawn")
	return null

# --- Entity spawning ---

func _spawn_entities():
	var spawner = _find_entity_spawner()
	if spawner == null:
		return
	if spawner.has_method("set_game_manager"):
		spawner.set_game_manager(game_manager)
	if spawner.has_method("spawn_entities"):
		spawner.spawn_entities()
		if spawner.has_method("get_spawned_entities"):
			entities_spawned.emit(spawner.get_spawned_entities())

func _find_entity_spawner() -> Node:
	var nodes = get_tree().get_nodes_in_group(entity_spawner_group)
	if nodes.size() > 0:
		return nodes[0]
	if current_level != null and current_level.has_node("EntitySpawner"):
		return current_level.get_node("EntitySpawner")
	return null
