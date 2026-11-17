extends ColorRect

var sanity_system: Node = null

func _process(_delta):
	if sanity_system == null:
		sanity_system = get_tree().get_first_node_in_group("sanity_system")
		if sanity_system == null:
			return
	var s = sanity_system.sanity_level / sanity_system.max_sanity
	(material as ShaderMaterial).set_shader_parameter("sanity", s)
