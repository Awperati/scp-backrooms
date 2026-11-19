extends Node

func _ready():
	var mgr = get_parent()
	await get_tree().process_frame
	print("Level loaded: ", mgr.current_level != null)
	print("Player position: ", mgr.player.global_position)
	print("Spawn points: ", get_tree().get_nodes_in_group("spawn_point").size())
	print("Spawner found: ", mgr._find_entity_spawner() != null)
	get_tree().quit()
