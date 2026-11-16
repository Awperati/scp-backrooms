## Level transition manager. Handles loading levels, spawning entities, positioning player.
extends Node3D

@export var current_level: int = 0
var data_drives_collected: int = 0
var level_data: Dictionary = {}
var level_scenes: Dictionary = {}
var level_entities: Array[Node3D] = []

signal level_loaded(level_index)
signal level_cleared(level_index)
signal all_levels_cleared

func _ready() -> void:
	_load_level_data()
	_load_all_scenes()
	_load_level(current_level)

func _load_level_data() -> void:
	var file = FileAccess.open("res://data/level_definitions.json", FileAccess.READ)
	if file:
		var json = file.get_as_text()
		file.close()
		var parsed = JSON.parse_string(json)
		if parsed:
			level_data = parsed

func _load_all_scenes() -> void:
	var levels = level_data.get("levels", [])
	for level in levels:
		var scene_path = level.get("scene", "")
		if scene_path:
			var scene = load(scene_path)
			if scene:
				level_scenes[level.get("id", -1)] = scene

func _load_level(level_index: int) -> void:
	current_level = level_index
	data_drives_collected = 0
	level_entities.clear()
	
	# Get level info
	var levels = level_data.get("levels", [])
	if level_index >= levels.size():
		return
	
	var level_info = levels[level_index]
	var entities = level_info.get("entities", [])
	var spawn_points = level_info.get("spawn_points", [])
	
	# Spawn entities from level definition
	for entity_config in entities:
		var type_name = entity_config.get("type", "")
		var count = entity_config.get("count", 1)
		var entity_spawn_points = entity_config.get("spawn_points", [])
		
		for i in range(count):
			_spawn_entity(type_name, entity_spawn_points, i)
	
	level_loaded.emit(level_index)

func _spawn_entity(type_name: String, spawn_points: Array, index: int) -> void:
	var entity_scene = load("res://scenes/entities/entity_%s.tscn" % type_name)
	if entity_scene:
		var entity = entity_scene.instantiate()
		
		# Position at spawn point or random if not specified
		if spawn_points.size() > 0:
			var spawn_idx = index % spawn_points.size()
			var spawn_pos = Vector3(spawn_points[spawn_idx][0], 0, spawn_points[spawn_idx][1])
			entity.global_position = spawn_pos
		else:
			entity.global_position = Vector3(
				randf_range(-5.0, 5.0),
				0.0,
				randf_range(-5.0, 5.0)
			)
		
		level_entities.append(entity)
		add_child(entity)

func _on_exit_door_triggered(required_drives: int) -> void:
	if data_drives_collected >= required_drives:
		_load_next_level()

func _load_next_level() -> void:
	current_level += 1
	var levels = level_data.get("levels", [])
	
	if current_level >= levels.size():
		# All levels cleared
		all_levels_cleared.emit()
		return
	
	_load_level(current_level)
	level_cleared.emit(current_level)

func _on_data_drive_collected() -> void:
	data_drives_collected += 1

func _on_player_spawned() -> void:
	# Position player at spawn point
	var spawn = get_node("PlayerSpawn")
	if spawn:
		var player = get_node("/root/Game/Player")
		if player:
			player.global_position = spawn.global_position