## Hound entity with aggressive AI behavior
extends "res://scripts/entity.gd"

# Hound properties
@export var detection_range: float = 8.0
@export var attack_range: float = 1.5
@export var attack_cooldown: float = 2.0
@export var attack_damage: int = 25
@export var speed: float = 2.5

# AI state
var attack_timer: float = 0.0
var is_attacking: bool = false

func setup_ai() -> void:
	# Setup hound AI behavior
	print("Hound AI initialized")

func update_ai(delta: float) -> void:
	# Hound AI behavior
	if not is_alive:
		return
	
	# Update attack timer
	if attack_timer > 0:
		attack_timer -= delta
	
	# Check if player is in range
	var player_distance = global_position.distance_to(player.global_position)
	
	if player_distance < detection_range:
		# Move toward player
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		
		# Rotate to face player
		look_at(player.global_position, Vector3.UP)
		
		# Attack if in range
		if player_distance < attack_range and attack_timer <= 0:
			attack_player()
	else:
		# Idle behavior
		velocity = Vector3.ZERO

func attack_player() -> void:
	# Attack the player
	if game_controller and not is_attacking:
		is_attacking = true
		attack_timer = attack_cooldown
		
		# Damage player
		game_controller.damage_player(attack_damage)
		
		# Reset attack state
		# This would be done with a timer or animation
		is_attacking = false

func _on_player_detected(player: Node3D) -> void:
	# Handle player detection
	print("Hound detected player")

func _on_player_attacked(player: Node3D) -> void:
	# Handle player attack
	print("Hound attacked player")

func _on_player_in_range(player: Node3D) -> void:
	# Handle player in range
	print("Hound player in range")

# Signals
signal hound_attack