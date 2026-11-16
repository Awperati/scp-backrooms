## Watcher entity. Stationary turret, throws projectiles.
extends Node3D

var detection_range: float = 20.0
var detection_cone: float = 90.0
var attack_damage: float = 10.0
var attack_cooldown: float = 3.0
var lose_sight_timeout: float = 6.0

var attack_timer: float = 0.0
var lose_sight_timer: float = 0.0
var is_attacking: bool = false
var player: Node3D

func _ready() -> void:
	$EyeLight.light_energy = 0.0
	player = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	if not player:
		return
	
	var dist = global_position.distance_to(player.global_position)
	var dir_to_player = (player.global_position - global_position).normalized()
	
	# Check if player is in detection cone
	var forward = -global_transform.basis.z
	var angle = forward.angle_to(dir_to_player)
	
	if dist <= detection_range and angle <= deg_to_rad(detection_cone / 2.0):
		lose_sight_timer = 0.0
		$EyeLight.light_energy = 1.0
		is_attacking = true
		
		if dist <= detection_range * 0.5:
			_attack_player(delta)
		else:
			# Track player
			look_at(player.global_position, Vector3.UP)
	else:
		is_attacking = false
		lose_sight_timer += delta
		$EyeLight.light_energy = 0.2

func _attack_player(delta: float) -> void:
	attack_timer += delta
	if attack_timer >= attack_cooldown:
		_fire_projectile()
		attack_timer = 0.0

func _fire_projectile() -> void:
	var projectile = load("res://scenes/projectile.tscn").instantiate()
	projectile.global_position = $Eye.global_position
	projectile.target = player
	projectile.damage = attack_damage
	add_child(projectile)
