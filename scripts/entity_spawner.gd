## Entity spawner. Reads level definitions and spawns entities.
extends Node

func spawn_entities(level_index: int) -> void:
	var file = FileAccess.open("res://data/level_definitions.json", FileAccess.READ)
	if not file:
		return
	
	var json_text = file.get_as_text()
	file.close()
	
	var parsed = JSON.parse_string(json_text)
	if not parsed:
		return
	
	var levels = parsed.get("levels", [])
	if level_index >= levels.size():
		return
	
	var level = levels[level_index]
	var entities = level.get("entities", [])
	
	for entity_config in entities:
		var type_name = entity_config.get("type", "")
		var count = entity_config.get("count", 1)
		var spawn_points = entity_config.get("spawn_points", [])
		
		for i in range(count):
			var spawn_idx = i % spawn_points.size()
			var spawn_pos = Vector3(spawn_points[spawn_idx][0], 0, spawn_points[spawn_idx][1])
			
			var scene_path = "res://scenes/entities/entity_%s.tscn" % type_name
			var entity_scene = load(scene_path)
			if entity_scene:
				var entity = entity_scene.instantiate()
				entity.global_position = spawn_pos
				add_child(entity)
