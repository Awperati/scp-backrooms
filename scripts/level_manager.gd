## Level manager. Handles level transitions, entity spawning, exit checks.
extends Node3D

var current_level: int = 0
var data_drives_collected: int = 0
var level_data: Dictionary = {}

func _ready() -> void:
	_load_level_data()
	_load_level(current_level)

func _load_level_data() -> void:
	var file = FileAccess.open("res://data/level_definitions.json", FileAccess.READ)
	if file:
		var json = file.get_as_text()
		file.close()
		var parsed = JSON.parse_string(json)
		if parsed:
			level_data = parsed

func _load_level(level_index: int) -> void:
	current_level = level_index
	var level_info = level_data.get("levels", []).get(level_index, {})
	
	# Spawn entities
	var entities = level_info.get("entities", [])
	for entity_config in entities:
		var type_name = entity_config.get("type", "")
		var count = entity_config.get("count", 1)
		for i in range(count):
			_spawn_entity(type_name, entity_config)

func _spawn_entity(type_name: String, config: Dictionary) -> void:
	var spawn_points = config.get("spawn_points", [])
	var spawn_pos = spawn_points[randi() % spawn_points.size()] if spawn_points.size() > 0 else Vector3.ZERO
	
	var entity_scene = load("res://scenes/entities/entity_" + type_name + ".tscn")
	if entity_scene:
		var entity = entity_scene.instantiate()
		entity.global_position = spawn_pos
		add_child(entity)

func _on_exit_door_triggered(required_drives: int) -> void:
	if data_drives_collected >= required_drives:
		_load_next_level()

func _load_next_level() -> void:
	current_level += 1
	if current_level >= level_data.get("levels", []).size():
		# Game complete
		_show_victory()
		return
	_load_level(current_level)

func _show_victory() -> void:
	var title = get_tree().get_first_node_in_group("ui_title")
	if title:
		title.text = "YOU ESCAPED THE BACKROOMS"
		title.visible = true
