extends Node

# Sanity system
@export var sanity_decay_rate: float = 0.5
@export var sanity_recovery_rate: float = 0.2
@export var flicker_intensity: float = 1.0
@export var flicker_speed: float = 5.0

# References
var player: Node3D = null
var game_controller: Node = null
var sanity_shader: ShaderMaterial = null

func initialize():
	# Setup sanity system
	game_controller = get_tree().get_nodes_in_group("game_controller")[0] if get_tree().get_nodes_in_group("game_controller").size() > 0 else null
	player = get_tree().get_nodes_in_group("player")[0] if get_tree().get_nodes_in_group("player").size() > 0 else null
	
	# Get camera and shader
	var camera_nodes = get_tree().get_nodes_in_group("camera")
	if camera_nodes.size() > 0:
		var camera = camera_nodes[0] as Camera3D
		if camera != null:
			var viewport = camera.get_viewport()
			if viewport != null:
				sanity_shader = viewport.get_camera_3d().material

func update(delta):
	# Update sanity based on player state
	if player != null:
		var player_controller = player.get_script()
		if player_controller != null:
			# Apply sanity decay
			player_controller.reduce_sanity(sanity_decay_rate * delta)
			
			# Apply sanity recovery when safe
			if is_player_safe():
				player_controller.restore_sanity(sanity_recovery_rate * delta)
	
	# Update visual effects
	update_visual_effects()

func is_player_safe():
	# Check if player is in a safe area (not near entities)
	if player == null or game_controller == null:
		return false
	
	var entities = game_controller.get_entities_by_type("ANOMALOUS")
	for entity in entities:
		if entity != null:
			var distance = player.position.distance_to(entity.position)
			if distance < 5.0:  # Near entity
				return false
	return true

func update_visual_effects():
	# Update shader effects based on sanity level
	if sanity_shader != null and player != null:
		var player_controller = player.get_script()
		if player_controller != null:
			var sanity_level = player_controller.get_sanity_percentage()
			
			# Update flicker effect
			var flicker_amount = 1.0 - sanity_level
			sanity_shader.set_shader_parameter("flicker_intensity", flicker_amount * flicker_intensity)
			sanity_shader.set_shader_parameter("flicker_speed", flicker_amount * flicker_speed)