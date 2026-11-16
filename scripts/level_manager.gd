## Level manager. Handles level transitions, entity spawning, exit checks.
extends Node3D

var current_level: int = 0
var data_drives_collected: int = 0
var level_data: Dictionary = {}
var level_entities: Array[Node3D] = []

func _ready() -> void:
	_load_level_data()
	_load_level(current_level)
	
	# Connect signals
	GameController.sanity_changed.connect(_on_sanity_changed)
	GameController.game_over_emitted.connect(_on_game_over)

func _load_level_data() -> void:
	var file = FileAccess.open("res://data/level_definitions.json", FileAccess.READ)
	if file:
		var json = file.get_as_text()
		file.close()
		var parsed = JSON.parse_string(json)
		if parsed:
			level_data = parsed

func _on_sanity_changed(value: float) -> void:
	pass

func _on_game_over() -> void:
	var game_over = load("res://scenes/game_over.tscn").instantiate()
	get_tree().root.add_child(game_over)

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
	
	# Spawn entities from level definition
	for entity_config in entities:
		var type_name = entity_config.get("type", "")
		var count = entity_config.get("count", 1)
		var entity_spawn_points = entity_config.get("spawn_points", [])
		
		for i in range(count):
			_spawn_entity(type_name, entity_spawn_points, i)

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
		_show_victory()
		return
	
	_load_level(current_level)

func _show_victory() -> void:
	var victory = load("res://scenes/victory.tscn").instantiate()
	get_tree().root.add_child(victory)
