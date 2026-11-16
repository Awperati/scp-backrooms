extends Node

# Entity spawner for the SCP Backrooms game

# Configuration
var spawn_positions = []
var entity_types = ["smiler", "hound", "stalker", "watcher", "whisperer"]
var max_entities = 10
var current_entities = 0

func _ready():
	# Initialize spawn positions
	# This would normally be set from level data
	spawn_positions = [
		Vector2(5, 5),
		Vector2(10, 10),
		Vector2(15, 5),
		Vector2(5, 15),
		Vector2(15, 15)
	]

func spawn_entity(entity_type, position):
	# Spawn an entity of the specified type at the given position
	if current_entities >= max_entities:
		return null
	
	# Load the entity scene
	var entity_scene = preload("res://scenes/entities/entity_" + entity_type + ".tscn")
	
	# Instance the scene
	var entity = entity_scene.instantiate()
	entity.position = position
	
	# Add to scene
	add_child(entity)
	
	# Increment entity count
	current_entities += 1
	
	# Connect to entity destruction signal
	entity.connect("entity_destroyed", self, "on_entity_destroyed")
	
	return entity

func spawn_random_entity(position):
	# Spawn a random entity type at the given position
	var entity_type = entity_types[randi() % entity_types.size()]
	return spawn_entity(entity_type, position)

func on_entity_destroyed(entity):
	# Handle entity destruction
	current_entities -= 1

func spawn_entities_in_radius(center, radius, count):
	# Spawn multiple entities within a radius
	for i in range(count):
		var angle = randf() * 2 * PI
		var distance = randf() * radius
		var spawn_pos = center + Vector2(cos(angle) * distance, sin(angle) * distance)
		spawn_random_entity(spawn_pos)