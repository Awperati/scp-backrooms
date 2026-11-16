## Stalker entity. Teleports when player looks away, always behind player.
extends Node3D

var detection_range: float = 25.0
var chase_speed: float = 5.0
var attack_damage: float = 8.0
var attack_cooldown: float = 1.5

var teleport_timer: float = 0.0
var teleport_interval: float = 5.0
var attack_timer: float = 0.0
var flicker_timer: float = 0.0

func _ready() -> void:
	teleport_timer = randf() * teleport_interval
	$FlickerLight.light_energy = 0.0

func _process(delta: float) -> void:
	var player = get_node("/root/Game/Player") as Node3D
	if not player:
		return
	
	var dist = global_position.distance_to(player.global_position)
	var dir_to_player = (player.global_position - global_position).normalized()
	
	# Check if player is looking away
	var player_forward = player.global_transform.basis.z
	var dot = player_forward.dot(-dir_to_player)
	
	teleport_timer += delta
	
	if dot < 0 and teleport_timer >= teleport_interval:
		_teleport_behind_player(player)
		teleport_timer = 0.0
		_flicker()
	
	# Flicker effect
	if flicker_timer > 0:
		flicker_timer -= delta
		$FlickerLight.light_energy = randf() * 2.0
	else:
		$FlickerLight.light_energy = 0.0
	
	if dist <= detection_range * 0.5 and not is_on_floor():
		_move_toward_player(delta)
	elif dist <= detection_range * 0.3:
		_attack_player(delta)
	
	# Face player
	look_at(player.global_position, Vector3.UP)

func _teleport_behind_player(player: Node3D) -> void:
	var behind_pos = player.global_position - player.global_transform.basis.z * 3.0
	behind_pos.y = global_position.y
	global_position = behind_pos

func _move_toward_player(delta: float) -> void:
	var player = get_node("/root/Game/Player") as Node3D
	if not player:
		return
	
	var dir = (player.global_position - global_position).normalized()
	position += dir * chase_speed * delta

func _attack_player(delta: float) -> void:
	attack_timer += delta
	if attack_timer >= attack_cooldown:
		GameController.lose_sanity(attack_damage)
		attack_timer = 0.0

func _flicker() -> void:
	$FlickerLight.light_energy = 2.0
	flicker_timer = 0.5
