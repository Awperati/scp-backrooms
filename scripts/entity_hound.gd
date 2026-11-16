extends "res://scripts/entity_base.gd"

# Hound Entity for 3D version
# This class implements the specific behavior for the Hound entity in 3D

# Entity-specific properties
@export var patrol_points: Array[Vector3] = []
@export var current_patrol_index: int = 0
@export var attack_cooldown: float = 1.5
var last_attack_time: float = 0.0

# Animation and visual properties
@onready var animation_player = $AnimationPlayer

# Initialize the Hound entity
func _ready():
	# Call parent initialization
	super._ready()
	
	# Set entity-specific properties
	entity_type = "HOUND"
	max_health = 100.0
	health = max_health
	speed = 3.0
	detection_range = 10.0
	attack_range = 2.0
	damage = 30.0
	
	# Initialize patrol points (3D)
	patrol_points = [
		Vector3(-60, 0, -60),
		Vector3(60, 0, -60),
		Vector3(60, 0, 60),
		Vector3(-60, 0, 60)
	]
	current_patrol_index = 0

# Process function for behavior
func _process(delta):
	# Call parent process
	super._process(delta)
	
	if player != null and is_alive:
		var distance_to_player = position.distance_to(player.position)
		
		# If player is close enough to attack, attack
		if distance_to_player <= attack_range:
			attack_player(delta)
		# If player is in detection range, start chasing
		elif distance_to_player <= detection_range:
			chase_player(delta)
		else:
			patrol(delta)
		# Apply movement
		move_and_slide()

# Chase the player
func chase_player(delta):
	if player == null:
		return
	
	var direction = (player.position - position).normalized()
	velocity = direction * speed
	
	# Rotate to face player (Y-axis rotation for 3D)
	if direction != Vector3.ZERO:
		rotation.y = atan2(direction.x, direction.z)

# Patrol around the level
func patrol(delta):
	if patrol_points.size() == 0:
		velocity = Vector3.ZERO
		return
	
	# Move to next patrol point
	var target_point = patrol_points[current_patrol_index]
	var direction = (target_point - position).normalized()
	var distance_to_target = position.distance_to(target_point)
	
	velocity = direction * speed * 0.5  # Slower during patrol
	
	# Rotate to face direction (Y-axis rotation for 3D)
	if direction != Vector3.ZERO:
		rotation.y = atan2(direction.x, direction.z)
	
	# If reached target point, move to next
	if distance_to_target < 2.0:
		current_patrol_index = (current_patrol_index + 1) % patrol_points.size()

# Attack the player
func attack_player(delta):
	if player == null:
		return
	
	# Check attack cooldown
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - last_attack_time < attack_cooldown:
		return
	
	last_attack_time = current_time
	velocity = Vector3.ZERO  # Stop moving during attack
	
	# Perform attack
	player.take_damage(damage)
	
	# Play attack animation
	if animation_player.has_animation("attack"):
		animation_player.play("attack")

# Handle damage
func _on_health_changed(new_health: float, max_health: float):
	if animation_player.has_animation("damage"):
		animation_player.play("damage")

# Handle death
func _on_entity_killed(entity):
	if animation_player.has_animation("death"):
		animation_player.play("death")