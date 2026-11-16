extends Node3D

# Manages entities in the game world

@onready var entities = []
@onready var active_entities = []

func _ready():
	# Initialize entity manager
	print("Entity manager ready")

func add_entity(entity):
	# Add a new entity to the game
	if not entity in entities:
		entities.append(entity)
		active_entities.append(entity)
		print("Added entity: " + entity.name)

func remove_entity(entity):
	# Remove an entity from the game
	if entity in entities:
		entities.erase(entity)
		if entity in active_entities:
			active_entities.erase(entity)
		print("Removed entity: " + entity.name)

func get_entities():
	return entities

func get_active_entities():
	return active_entities

func get_entity_by_type(type_name):
	for entity in active_entities:
		if entity.has_method("get_entity_type") and entity.get_entity_type() == type_name:
			return entity
	return null

func get_entity_count_by_type(type_name):
	var count = 0
	for entity in active_entities:
		if entity.has_method("get_entity_type") and entity.get_entity_type() == type_name:
			count += 1
	return count