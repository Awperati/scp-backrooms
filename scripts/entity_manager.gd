extends Node

# Entity management
var entities: Array[Node] = []

func initialize():
	pass

func update(delta):
	# Update all entities
	for entity in entities:
		if entity != null:
			entity._process(delta)

func add_entity(entity: Node):
	entities.append(entity)

func remove_entity(entity: Node):
	entities.erase(entity)

func get_entities_by_type(entity_type: String) -> Array[Node]:
	var result: Array[Node] = []
	for entity in entities:
		if entity.entity_type == entity_type:
			result.append(entity)
	return result

func get_all_entities() -> Array[Node]:
	return entities

func clear_entities():
	entities.clear()