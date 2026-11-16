## Entity AI behavior manager. Handles state transitions for entities.
extends Node3D

@export var lose_sight_timeout: float = 5.0
@export var noise_attraction_range: float = 15.0

var player: Node3D
var last_sight_time: float = 0.0
var is_sprinting: bool = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	if not player:
		# Try to find player via GameController or scene tree
		player = get_node("/root/Game/Player")

func _process(delta: float) -> void:
	if not player:
		return
	
	# Check line of sight
	var dir = (player.global_position - global_position).normalized()
	var ray = PhysicsRayQuery3D.create(global_position, player.global_position)
	var space = get_world_3d().direct_space_state
	var hit = space.intersect_ray(ray)
	
	if hit:
		var hit_pos = hit.position
		var player_pos = player.global_position
		if hit_pos.distance_to(player_pos) > 0.5:
			# Hit something between entity and player
			lose_sight_time += delta
			if lose_sight_time >= lose_sight_timeout:
				# Lost sight
				pass
		else:
			lose_sight_time = 0.0
	else:
		lose_sight_time = 0.0
