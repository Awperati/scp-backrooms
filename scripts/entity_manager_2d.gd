extends Node2D

# Entity Manager for SCP Backrooms - 2D version
# Handles spawning, managing, and updating all entities

# Entity lists
var entities: Array = []
var active_entities: Array = []
var entity_counts: Dictionary = {}

# Spawn settings
@export var spawn_interval: float = 1.0
var last_spawn_time: float = 0.0

# Game references
var game_manager: Node2D = null
var entity_spawner: Node2D = null
var entity_interaction_system: Node2D = null

# Signals
signal entity_spawned(entity)
signal entity_destroyed(entity)
signal entity_added(entity)
signal entity_removed(entity)
signal all_entities_destroyed()

func _ready():
	# Initialize entity manager
	add_to_group("entity_manager")
	
	# Setup entity manager
	setup_entity_manager()

func setup_entity_manager():
	# Initialize entity counts
	entity_counts = {
		"smiler": 0,
		"stalker": 0,
		"hound": 0,
		"watcher": 0,
		"whisperer": 0
	}

func set_game_manager(new_game_manager: Node2D):
	game_manager = new_game_manager

func set_entity_spawner(new_spawner: Node2D):
	entity_spawner = new_spawner

func set_entity_interaction_system(new_interaction_system: Node2D):
	entity_interaction_system = new_interaction_system

func _process(delta):
	# Update entity manager
	update_entity_manager(delta)

func update_entity_manager(delta: float):
	# Update spawn timer
	last_spawn_time += delta
	
	# Spawn entities if needed
	if last_spawn_time >= spawn_interval:
		spawn_entities()
		last_spawn_time = 0.0

func spawn_entities():
	# Spawn entities based on current level requirements
	if entity_spawner != null:
		entity_spawner.spawn_entities()

func add_entity(entity: Node2D):
	# Add an entity to the manager
	if entity == null:
		return
	
	# Add to lists
	entities.append(entity)
	active_entities.append(entity)
	
	# Update entity counts
	var entity_type = entity.get_entity_type()
	if entity_counts.has(entity_type):
		entity_counts[entity_type] += 1
	
	# Set references
	entity.set_entity_manager_ref(self)
	entity.set_game_manager_ref(game_manager)
	entity.set_entity_interaction_system_ref(entity_interaction_system)
	
	# Connect signals
	entity.connect("entity_destroyed", self, "on_entity_destroyed")
	
	# Emit signal
	emit_signal("entity_added", entity)

func remove_entity(entity: Node2D):
	# Remove an entity from the manager
	if entity == null:
		return
	
	# Remove from lists
	if entities.has(entity):
		entities.erase(entity)
	
	if active_entities.has(entity):
		active_entities.erase(entity)
	
	# Update entity counts
	var entity_type = entity.get_entity_type()
	if entity_counts.has(entity_type):
		entity_counts[entity_type] -= 1
	
	# Emit signal
	emit_signal("entity_removed", entity)

func on_entity_destroyed(entity: Node2D):
	# Handle entity destruction
	if entity == null:
		return
	
	# Remove from lists
	if entities.has(entity):
		entities.erase(entity)
	
	if active_entities.has(entity):
		active_entities.erase(entity)
	
	# Update entity counts
	var entity_type = entity.get_entity_type()
	if entity_counts.has(entity_type):
		entity_counts[entity_type] -= 1
	
	# Emit signal
	emit_signal("entity_destroyed", entity)
	
	# Check if all entities are destroyed
	if entities.size() == 0:
		emit_signal("all_entities_destroyed")

func get_entities() -> Array:
	return entities

func get_active_entities() -> Array:
	return active_entities

func get_entity_count() -> int:
	return entities.size()

func get_entity_count_by_type(entity_type: String) -> int:
	if entity_counts.has(entity_type):
		return entity_counts[entity_type]
	return 0

func get_entity_by_type(entity_type: String) -> Array:
	# Get entities by type
	var result = []
	for entity in entities:
		if entity.get_entity_type() == entity_type:
			result.append(entity)
	return result

func get_entity_by_name(entity_name: String) -> Node2D:
	# Get entity by name
	for entity in entities:
		if entity.get_entity_name() == entity_name:
			return entity
	return null

func get_entity_by_id(entity_id: String) -> Node2D:
	# Get entity by ID
	for entity in entities:
		if entity.name == entity_id:
			return entity
	return null

func get_entity_by_position(position: Vector2) -> Node2D:
	# Get entity by position
	for entity in entities:
		if entity.position.distance_to(position) < 10:
			return entity
	return null

func get_entities_in_range(position: Vector2, range: float) -> Array:
	# Get entities in range
	var result = []
	for entity in entities:
		if entity.position.distance_to(position) <= range:
			result.append(entity)
	return result

func get_nearest_entity(position: Vector2) -> Node2D:
	# Get nearest entity to position
	var nearest_entity = null
	var nearest_distance = INF
	
	for entity in entities:
		var distance = entity.position.distance_to(position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_entity = entity
	
	return nearest_entity

func get_entities_by_detection_state(detection_state: bool) -> Array:
	# Get entities by detection state
	var result = []
	for entity in entities:
		if entity.is_detected == detection_state:
			result.append(entity)
	return result

func get_entity_manager_settings() -> Dictionary:
	# Get entity manager settings
	return {
		"spawn_interval": spawn_interval,
		"last_spawn_time": last_spawn_time
	}

func set_entity_manager_settings(settings: Dictionary):
	# Set entity manager settings
	for key in settings.keys():
		match key:
			"spawn_interval":
				spawn_interval = settings[key]
			"last_spawn_time":
				last_spawn_time = settings[key]

func set_game_manager_ref(game_manager_ref: Node2D):
	game_manager = game_manager_ref

func set_entity_spawner_ref(spawner_ref: Node2D):
	entity_spawner = spawner_ref

func set_entity_interaction_system_ref(interaction_system_ref: Node2D):
	entity_interaction_system = interaction_system_ref

func get_game_manager() -> Node2D:
	return game_manager

func get_entity_spawner() -> Node2D:
	return entity_spawner

func get_entity_interaction_system() -> Node2D:
	return entity_interaction_system

func spawn_entity(entity_type: String, spawn_point: Vector2) -> Node2D:
	# Spawn an entity at a specific point
	var entity_scene = preload("res://scenes/entities/entity_2d_" + entity_type + ".tscn")
	
	# Create entity
	var entity = entity_scene.instantiate()
	
	# Set position
	entity.position = spawn_point
	
	# Add to scene
	add_child(entity)
	
	# Add to manager
	add_entity(entity)
	
	# Emit signal
	emit_signal("entity_spawned", entity)
	
	return entity

func spawn_entity_at_spawn_point(spawn_point_node: Node2D) -> Node2D:
	# Spawn an entity at a spawn point
	var entity_type = spawn_point_node.get_entity_type()
	var entity_scene = preload("res://scenes/entities/entity_2d_" + entity_type + ".tscn")
	
	# Create entity
	var entity = entity_scene.instantiate()
	
	# Set position
	entity.position = spawn_point_node.position
	
	# Add to scene
	add_child(entity)
	
	# Add to manager
	add_entity(entity)
	
	# Emit signal
	emit_signal("entity_spawned", entity)
	
	return entity

func spawn_entities_at_spawn_points(spawn_points: Array) -> Array:
	# Spawn multiple entities at spawn points
	var spawned_entities = []
	
	for spawn_point in spawn_points:
		var entity = spawn_entity_at_spawn_point(spawn_point)
		spawned_entities.append(entity)
	
	return spawned_entities

func destroy_all_entities():
	# Destroy all entities
	for entity in entities.duplicate():
		if entity != null and entity.is_alive:
			entity.queue_free()
	
	# Clear lists
	entities.clear()
	active_entities.clear()
	
	# Reset entity counts
	for key in entity_counts.keys():
		entity_counts[key] = 0
	
	# Emit signal
	emit_signal("all_entities_destroyed")

func get_all_entity_counts() -> Dictionary:
	# Get all entity counts
	return entity_counts

func update_entity_counts():
	# Update entity counts
	for key in entity_counts.keys():
		entity_counts[key] = 0
	
	for entity in entities:
		var entity_type = entity.get_entity_type()
		if entity_counts.has(entity_type):
			entity_counts[entity_type] += 1

func is_entity_manager_active() -> bool:
	# Check if entity manager is active
	return is_inside_tree()

func set_entity_manager_active(active: bool):
	# Set entity manager active state
	if active:
		set_process(true)
	else:
		set_process(false)

func set_spawn_interval(interval: float):
	spawn_interval = interval

func get_spawn_interval() -> float:
	return spawn_interval

func set_last_spawn_time(time: float):
	last_spawn_time = time

func get_last_spawn_time() -> float:
	return last_spawn_time

func get_entity_manager_properties() -> Dictionary:
	# Get entity manager properties
	return {
		"entities": entities.size(),
		"active_entities": active_entities.size(),
		"entity_counts": entity_counts
	}

func set_entity_manager_properties(properties: Dictionary):
	# Set entity manager properties
	for key in properties.keys():
		match key:
			"entities":
				entities = properties[key]
			"active_entities":
				active_entities = properties[key]
			"entity_counts":
				entity_counts = properties[key]

func get_entity_manager_stats() -> Dictionary:
	# Get entity manager statistics
	return {
		"entities": entities.size(),
		"active_entities": active_entities.size(),
		"entity_counts": entity_counts,
		"spawn_interval": spawn_interval,
		"last_spawn_time": last_spawn_time
	}

func set_entity_manager_stats(stats: Dictionary):
	# Set entity manager statistics
	for key in stats.keys():
		match key:
			"entities":
				entities = stats[key]
			"active_entities":
				active_entities = stats[key]
			"entity_counts":
				entity_counts = stats[key]
			"spawn_interval":
				spawn_interval = stats[key]
			"last_spawn_time":
				last_spawn_time = stats[key]