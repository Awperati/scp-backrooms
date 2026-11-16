extends Node

static func change_scene(scene_path: String):
	# Create a new scene instance
	var scene = preload(scene_path).instantiate()
	
	# Get the current main scene
	var current_scene = get_tree().current_scene
	
	# Add the new scene to the tree
	get_tree().add_child(scene)
	
	# Remove the current scene
	if current_scene != null:
		get_tree().remove_child(current_scene)
	
	# Set the new scene as the current scene
	get_tree().current_scene = scene
	
	# Call ready on the new scene
	scene._ready()