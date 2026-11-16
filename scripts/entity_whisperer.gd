## Whisperer entity with psychological manipulation behavior
extends "res://scripts/entity.gd"

# Whisperer properties
@export var detection_range: float = 7.0
@export var attack_range: float = 2.5
@export var attack_cooldown: float = 6.0
@export var attack_damage: int = 25
@export var speed: float = 1.8

# AI state
var attack_timer: float = 0.0
var is_attacking: bool = false
var is_manipulating: bool = false

func setup_ai() -> void:
	# Setup whisperer AI behavior
	print("Whisperer AI initialized")

func update_ai(delta: float) -> void:
	# Whisperer AI behavior
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
		
		# Manipulate player if close enough
		if player_distance < attack_range * 0.7:
			manipulate_player()
		
		# Attack if in range and cooldown is over
		if player_distance < attack_range and attack_timer <= 0:
			attack_player()
	else:
		# Idle behavior
		velocity = Vector3.ZERO

func manipulate_player() -> void:
	# Manipulate player psychology
	if not is_manipulating:
		is_manipulating = true
		# This would implement psychological manipulation
		# For now just a placeholder
		print("Whisperer manipulating player")

func attack_player() -> void:
	# Attack the player
	if game_controller and not is_attacking:
		is_attacking = true
		attack_timer = attack_cooldown
		
		# Damage player
		game_controller.damage_player(attack_damage)
		
		# Reset attack state
		is_attacking = false

func _on_player_detected(player: Node3D) -> void:
	# Handle player detection
	print("Whisperer detected player")

func _on_player_attacked(player: Node3D) -> void:
	# Handle player attack
	print("Whisperer attacked player")

func _on_player_in_range(player: Node3D) -> void:
	# Handle player in range
	print("Whisperer player in range")

# Signals
signal whisperer_attack