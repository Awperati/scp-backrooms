## Base entity script. All entity types extend this.
extends Node3D

enum Type { STATIC, TURRET, DESTRUCTIVE, ANOMALOUS }

@export var entity_type: Type = Type.STATIC
@export var detection_radius: float = 10.0
@export var chase_speed: float = 4.0
@export var attack_damage: float = 10.0
@export var attack_cooldown: float = 2.0
@export var retreat_timeout: float = 5.0

enum State { IDLE, ALERT, CHASE, ATTACK, RETREAT }
var state: State = State.IDLE

var player: Node3D
var player_detected: bool = false
var last_seen_position: Vector3
var attack_timer: float = 0.0
var retreat_timer: float = 0.0
var patrol_waypoints: Array[Vector3] = []
var current_patrol_index: int = 0
var noise_source: Vector3 = Vector3.ZERO
var noise_timer: float = 0.0

signal entity_attacked

func _ready() -> void:
	# Generate random patrol waypoints
	for i in range(4):
		var wp = Vector3(
			randf_range(-7.0, 7.0),
			0.0,
			randf_range(-7.0, 7.0)
		)
		patrol_waypoints.append(wp)

func _process(delta: float) -> void:
	_update_state(delta)
	_execute_state(delta)

func _update_state(delta: float) -> void:
	if not player:
		return
	
	var dist = global_position.distance_to(player.global_position)
	
	match state:
		State.IDLE:
			if dist <= detection_radius:
				state = State.ALERT
		State.ALERT:
			if dist > detection_radius * 1.5:
				_retreat()
			elif dist <= detection_radius * 0.5:
				state = State.CHASE
		State.CHASE:
			if dist > detection_radius * 2.0:
				_retreat()
			elif dist <= detection_radius * 0.3:
				state = State.ATTACK
		State.ATTACK:
			attack_timer += delta
			if attack_timer >= attack_cooldown:
				state = State.CHASE
				attack_timer = 0.0
		State.RETREAT:
			retreat_timer += delta
			if retreat_timer >= retreat_timeout:
				state = State.IDLE
				retreat_timer = 0.0

func _execute_state(delta: float) -> void:
	if not player:
		return
	
	match state:
		State.IDLE:
			_patrol(delta)
		State.ALERT:
			_move_toward_player(delta)
		State.CHASE:
			_move_toward_player(delta)
		State.ATTACK:
			_attack_player()
		State.RETREAT:
			_retreat_to_position(delta)

func _patrol(delta: float) -> void:
	if patrol_waypoints.is_empty():
		return
	
	var target = patrol_waypoints[current_patrol_index]
	var dir = (target - global_position).normalized()
	var speed = chase_speed * 0.5
	position += dir * speed * delta
	
	if global_position.distance_to(target) < 0.5:
		current_patrol_index = (current_patrol_index + 1) % patrol_waypoints.size()

func _move_toward_player(delta: float) -> void:
	if not player:
		return
	
	var dir = (player.global_position - global_position).normalized()
	position += dir * chase_speed * delta

func _attack_player() -> void:
	if not player:
		return
	
	var dist = global_position.distance_to(player.global_position)
	if dist <= detection_radius * 0.3:
		GameController.lose_sanity(attack_damage)
		entity_attacked.emit()

func _retreat() -> void:
	state = State.RETREAT
	retreat_timer = 0.0
	# Move toward last known safe position
	last_seen_position = global_position + Vector3(0, 0, 5)

func _retreat_to_position(delta: float) -> void:
	var dir = (last_seen_position - global_position).normalized()
	position += dir * chase_speed * 0.5 * delta
