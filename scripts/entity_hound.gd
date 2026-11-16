## Hound entity. Patrols corridors, chases player when detected.
extends Node3D

var detection_radius: float = 15.0
var chase_speed: float = 6.0
var attack_damage: float = 15.0
var attack_cooldown: float = 2.0
var retreat_timeout: float = 8.0

enum State { IDLE, ALERT, CHASE, ATTACK, RETREAT }
var state: State = State.IDLE
var attack_timer: float = 0.0
var retreat_timer: float = 0.0
var patrol_waypoints: Array[Vector3] = []
var current_patrol_index: int = 0
var last_seen_position: Vector3 = Vector3.ZERO

func _ready() -> void:
	# Generate patrol waypoints
	for i in range(4):
		patrol_waypoints.append(Vector3(
			randf_range(-7.0, 7.0),
			0.0,
			randf_range(-7.0, 7.0)
		))
		$EyesLight1.light_energy = 0.5
		$EyesLight2.light_energy = 0.5

func _process(delta: float) -> void:
	var player = get_node("/root/Game/Player") as Node3D
	if not player:
		return
	
	var dist = global_position.distance_to(player.global_position)
	
	match state:
		State.IDLE:
			if dist <= detection_radius:
				state = State.ALERT
			else:
				_patrol(delta)
		State.ALERT:
			if dist > detection_radius * 1.5:
				_retreat()
			elif dist <= detection_radius * 0.5:
				state = State.CHASE
			else:
				_move_toward_player(delta)
		State.CHASE:
			if dist > detection_radius * 2.0:
				_retreat()
			elif dist <= detection_radius * 0.3:
				state = State.ATTACK
			else:
				_move_toward_player(delta)
		State.ATTACK:
			attack_timer += delta
			if attack_timer >= attack_cooldown:
				state = State.CHASE
				attack_timer = 0.0
			elif dist <= detection_radius * 0.3:
				_attack_player()
		State.RETREAT:
			retreat_timer += delta
			if retreat_timer >= retreat_timeout:
				state = State.IDLE
				retreat_timer = 0.0
			else:
				_retreat_to_position(delta)

func _patrol(delta: float) -> void:
	if patrol_waypoints.is_empty():
		return
	
	var target = patrol_waypoints[current_patrol_index]
	var dir = (target - global_position).normalized()
	var speed = chase_speed * 0.3
	position += dir * speed * delta
	
	if global_position.distance_to(target) < 0.5:
		current_patrol_index = (current_patrol_index + 1) % patrol_waypoints.size()

func _move_toward_player(delta: float) -> void:
	var player = get_node("/root/Game/Player") as Node3D
	if not player:
		return
	
	var dir = (player.global_position - global_position).normalized()
	position += dir * chase_speed * delta

func _attack_player() -> void:
	var player = get_node("/root/Game/Player") as Node3D
	if not player:
		return
	
	var dist = global_position.distance_to(player.global_position)
	if dist <= detection_radius * 0.3:
		GameController.lose_sanity(attack_damage)

func _retreat() -> void:
	state = State.RETREAT
	retreat_timer = 0.0
	last_seen_position = global_position + Vector3(0, 0, 5)

func _retreat_to_position(delta: float) -> void:
	var dir = (last_seen_position - global_position).normalized()
	position += dir * chase_speed * 0.5 * delta
