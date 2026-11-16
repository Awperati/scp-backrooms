extends Node2D

# Entity Spawner for SCP Backrooms - 2D version
# Handles spawning entities based on level requirements

# Spawn point settings
var spawn_points: Array = []
var spawn_point_groups: Dictionary = {}

# Entity spawn settings
var entity_spawn_settings: Dictionary = {}
var current_level: int = 1
var max_entities_per_level: int = 10
var entities_to_spawn: int = 0

# Game references
var game_manager: Node2D = null
var entity_manager: Node2D = null
var entity_interaction_system: Node2D = null

# Signals
signal spawn_points_loaded(spawn_points)
signal entities_spawned(entities)
signal spawn_point_added(spawn_point)
signal spawn_point_removed(spawn_point)

func _ready():
	# Initialize entity spawner
	add_to_group("entity_spawner")
	
	# Setup entity spawner
	setup_entity_spawner()

func setup_entity_spawner():
	# Initialize spawn point groups
	spawn_point_groups = {
		"smiler": [],
		"stalker": [],
		"hound": [],
		"watcher": [],
		"whisperer": []
	}
	
	# Initialize entity spawn settings
	entity_spawn_settings = {
		"smiler": {"count": 1, "spawn_chance": 0.8},
		"stalker": {"count": 1, "spawn_chance": 0.7},
		"hound": {"count": 1, "spawn_chance": 0.6},
		"watcher": {"count": 1, "spawn_chance": 0.5},
		"whisperer": {"count": 1, "spawn_chance": 0.4}
	}

func set_game_manager(new_game_manager: Node2D):
	game_manager = new_game_manager

func set_entity_manager(new_entity_manager: Node2D):
	entity_manager = new_entity_manager

func set_entity_interaction_system(new_interaction_system: Node2D):
	entity_interaction_system = new_interaction_system

func load_spawn_points(level: int):
	# Load spawn points for a level
	var level_scene_path = "res://scenes/levels/level_" + str(level) + ".tscn"
	var level_scene = preload(level_scene_path)
	
	if level_scene != null:
		var level_instance = level_scene.instantiate()
		
		# Get spawn points
		var spawn_points_container = level_instance.get_node("SpawnPoints")
		if spawn_points_container != null:
			for child in spawn_points_container.get_children():
				if child.name.begins_with("spawn_point"):
					spawn_points.append(child)
					
					# Add to groups
					var entity_type = child.get_entity_type()
					if spawn_point_groups.has(entity_type):
						spawn_point_groups[entity_type].append(child)
		
		# Emit signal
		emit_signal("spawn_points_loaded", spawn_points)
		
		# Clean up
		level_instance.queue_free()

func add_spawn_point(spawn_point: Node2D):
	# Add a spawn point
	if spawn_point == null:
		return
	
	spawn_points.append(spawn_point)
	
	# Add to groups
	var entity_type = spawn_point.get_entity_type()
	if spawn_point_groups.has(entity_type):
		spawn_point_groups[entity_type].append(spawn_point)
	
	# Emit signal
	emit_signal("spawn_point_added", spawn_point)

func remove_spawn_point(spawn_point: Node2D):
	# Remove a spawn point
	if spawn_point == null:
		return
	
	if spawn_points.has(spawn_point):
		spawn_points.erase(spawn_point)
	
	# Remove from groups
	var entity_type = spawn_point.get_entity_type()
	if spawn_point_groups.has(entity_type):
		if spawn_point_groups[entity_type].has(spawn_point):
			spawn_point_groups[entity_type].erase(spawn_point)
	
	# Emit signal
	emit_signal("spawn_point_removed", spawn_point)

func spawn_entities():
	# Spawn entities based on current level
	if entity_manager == null:
		return
	
	# Get spawn points for this level
	var level_spawn_points = get_spawn_points_for_level(current_level)
	
	# Calculate entities to spawn
	entities_to_spawn = min(max_entities_per_level, level_spawn_points.size())
	
	# Spawn entities
	var spawned_entities = []
	
	for i in range(entities_to_spawn):
		# Randomly select an entity type
		var entity_type = select_entity_type_by_level(current_level)
		
		# Get a random spawn point
		var spawn_point = get_random_spawn_point_for_type(entity_type)
		
		if spawn_point != null:
			# Spawn entity
			var entity = entity_manager.spawn_entity_at_spawn_point(spawn_point)
			spawned_entities.append(entity)
	
	# Emit signal
	emit_signal("entities_spawned", spawned_entities)

func select_entity_type_by_level(level: int) -> String:
	# Select entity type based on level
	var entity_types = ["smiler", "stalker", "hound", "watcher", "whisperer"]
	
	# Adjust spawn weights based on level
	var spawn_weights = []
	
	# Level 1 entities
	if level <= 1:
		spawn_weights = [0.3, 0.3, 0.2, 0.1, 0.1]
	elif level <= 2:
		spawn_weights = [0.2, 0.3, 0.2, 0.15, 0.15]
	elif level <= 3:
		spawn_weights = [0.15, 0.25, 0.25, 0.15, 0.2]
	elif level <= 4:
		spawn_weights = [0.1, 0.2, 0.3, 0.2, 0.2]
	else:
		spawn_weights = [0.05, 0.15, 0.25, 0.25, 0.3]
	
	# Choose entity type
	var rand = randf()
	var cumulative = 0.0
	
	for i in range(len(entity_types)):
		cumulative += spawn_weights[i]
		if rand <= cumulative:
			return entity_types[i]
	
	return entity_types[0]

func get_random_spawn_point_for_type(entity_type: String) -> Node2D:
	# Get a random spawn point for an entity type
	var available_points = spawn_point_groups[entity_type]
	
	if available_points.size() == 0:
		# Fallback to any spawn point
		available_points = spawn_points
	
	if available_points.size() > 0:
		return available_points[randi() % available_points.size()]
	
	return null

func get_spawn_points_for_level(level: int) -> Array:
	# Get spawn points for a level
	var result = []
	
	for point in spawn_points:
		if point.get_entity_type() != null:
			result.append(point)
	
	return result

func get_spawn_points_by_type(entity_type: String) -> Array:
	# Get spawn points by entity type
	return spawn_point_groups[entity_type]

func get_spawn_points() -> Array:
	# Get all spawn points
	return spawn_points

func set_current_level(level: int):
	current_level = level

func get_current_level() -> int:
	return current_level

func set_max_entities_per_level(max_count: int):
	max_entities_per_level = max_count

func get_max_entities_per_level() -> int:
	return max_entities_per_level

func get_entities_to_spawn() -> int:
	return entities_to_spawn

func get_entity_spawn_settings() -> Dictionary:
	return entity_spawn_settings

func set_entity_spawn_settings(settings: Dictionary):
	entity_spawn_settings = settings

func set_game_manager_ref(game_manager_ref: Node2D):
	game_manager = game_manager_ref

func set_entity_manager_ref(entity_manager_ref: Node2D):
	entity_manager = entity_manager_ref

func set_entity_interaction_system_ref(interaction_system_ref: Node2D):
	entity_interaction_system = interaction_system_ref

func get_game_manager() -> Node2D:
	return game_manager

func get_entity_manager() -> Node2D:
	return entity_manager

func get_entity_interaction_system() -> Node2D:
	return entity_interaction_system

func get_entity_spawner_properties() -> Dictionary:
	# Get entity spawner properties
	return {
		"spawn_points": spawn_points.size(),
		"spawn_point_groups": spawn_point_groups,
		"entity_spawn_settings": entity_spawn_settings,
		"current_level": current_level,
		"max_entities_per_level": max_entities_per_level,
		"entities_to_spawn": entities_to_spawn
	}

func set_entity_spawner_properties(properties: Dictionary):
	# Set entity spawner properties
	for key in properties.keys():
		match key:
			"spawn_points":
				spawn_points = properties[key]
			"spawn_point_groups":
				spawn_point_groups = properties[key]
			"entity_spawn_settings":
				entity_spawn_settings = properties[key]
			"current_level":
				current_level = properties[key]
			"max_entities_per_level":
				max_entities_per_level = properties[key]
			"entities_to_spawn":
				entities_to_spawn = properties[key]

func get_entity_spawner_settings() -> Dictionary:
	# Get entity spawner settings
	return {
		"spawn_points": spawn_points.size(),
		"spawn_point_groups": spawn_point_groups,
		"entity_spawn_settings": entity_spawn_settings,
		"current_level": current_level,
		"max_entities_per_level": max_entities_per_level,
		"entities_to_spawn": entities_to_spawn
	}

func set_entity_spawner_settings(settings: Dictionary):
	# Set entity spawner settings
	for key in settings.keys():
		match key:
			"spawn_points":
				spawn_points = settings[key]
			"spawn_point_groups":
				spawn_point_groups = settings[key]
			"entity_spawn_settings":
				entity_spawn_settings = settings[key]
			"current_level":
				current_level = settings[key]
			"max_entities_per_level":
				max_entities_per_level = settings[key]
			"entities_to_spawn":
				entities_to_spawn = settings[key]

func get_entity_spawner_stats() -> Dictionary:
	# Get entity spawner statistics
	return {
		"spawn_points": spawn_points.size(),
		"spawn_point_groups": spawn_point_groups,
		"entity_spawn_settings": entity_spawn_settings,
		"current_level": current_level,
		"max_entities_per_level": max_entities_per_level,
		"entities_to_spawn": entities_to_spawn
	}

func set_entity_spawner_stats(stats: Dictionary):
	# Set entity spawner statistics
	for key in stats.keys():
		match key:
			"spawn_points":
				spawn_points = stats[key]
			"spawn_point_groups":
				spawn_point_groups = stats[key]
			"entity_spawn_settings":
				entity_spawn_settings = stats[key]
			"current_level":
				current_level = stats[key]
			"max_entities_per_level":
				max_entities_per_level = stats[key]
			"entities_to_spawn":
				entities_to_spawn = stats[key]

func is_entity_spawner_active() -> bool:
	# Check if entity spawner is active
	return is_inside_tree()

func set_entity_spawner_active(active: bool):
	# Set entity spawner active state
	if active:
		set_process(true)
	else:
		set_process(false)