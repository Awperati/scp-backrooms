extends Node2D

# Spawn point — marks where an entity type can appear.
@export var entity_type: String = "smiler"

func _ready():
	add_to_group("spawn_point")

func get_entity_type() -> String:
	return entity_type
