## Stalker entity with stealth behavior
extends "res://scripts/entity.gd"

# Stalker properties
@export var detection_range: float = 6.0
@export var attack_range: float = 2.0
@export var attack_cooldown: float = 4.0
@export var attack_damage: int = 20
@export var speed: float = 2.0

# AI state
var attack_timer: float = 0.0
var is_attacking: bool = false
var is_hiding: bool = false

func setup_ai() -> void:
	# Setup stalker AI behavior
	print("Stalker AI initialized")

func update_ai(delta: float) -> void:
	# Stalker AI behavior
	if not is_alive:
		return
	
	# Update attack timer
	if attack_timer > 0:
		attack_timer -= delta
	
	# Check if player is in range
	var player_distance = global_position.distance_to(player.global_position)
	
	if player_distance < detection_range:
		# Move toward player slowly
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		
		# Rotate to face player
		look_at(player.global_position, Vector3.UP)
		
		# Hide if player is too close
		if player_distance < attack_range * 0.5:
			hide_in_shadows()
		
		# Attack if in range and cooldown is over
		if player_distance < attack_range and attack_timer <= 0:
			attack_player()
	else:
		# Idle behavior
		velocity = Vector3.ZERO

func hide_in_shadows() -> void:
	# Hide in shadows or avoid detection
	if not is_hiding:
		is_hiding = true
		# This would implement hiding behavior
		# For now just a placeholder
		print("Stalker hiding in shadows")

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
	print("Stalker detected player")

func _on_player_attacked(player: Node3D) -> void:
	# Handle player attack
	print("Stalker attacked player")

func _on_player_in_range(player: Node3D) -> void:
	# Handle player in range
	print("Stalker player in range")

# Signals
signal stalker_attack