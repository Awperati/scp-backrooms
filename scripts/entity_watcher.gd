## Watcher entity with observation behavior
extends "res://scripts/entity.gd"

# Watcher properties
@export var detection_range: float = 10.0
@export var attack_range: float = 3.0
@export var attack_cooldown: float = 5.0
@export var attack_damage: int = 30
@export var speed: float = 1.0

# AI state
var attack_timer: float = 0.0
var is_attacking: bool = false
var is_observing: bool = false

func setup_ai() -> void:
	# Setup watcher AI behavior
	print("Watcher AI initialized")

func update_ai(delta: float) -> void:
	# Watcher AI behavior
	if not is_alive:
		return
	
	# Update attack timer
	if attack_timer > 0:
		attack_timer -= delta
	
	# Check if player is in range
	var player_distance = global_position.distance_to(player.global_position)
	
	if player_distance < detection_range:
		# Observe player
		if not is_observing:
			is_observing = true
			# This would implement observation behavior
			# For now just a placeholder
			print("Watcher observing player")
		
		# Rotate to face player
		look_at(player.global_position, Vector3.UP)
		
		# Attack if in range and cooldown is over
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
		is_attacking = false

func _on_player_detected(player: Node3D) -> void:
	# Handle player detection
	print("Watcher detected player")

func _on_player_attacked(player: Node3D) -> void:
	# Handle player attack
	print("Watcher attacked player")

func _on_player_in_range(player: Node3D) -> void:
	# Handle player in range
	print("Watcher player in range")

# Signals
signal watcher_attack