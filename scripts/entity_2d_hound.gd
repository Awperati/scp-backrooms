extends "res://scripts/entity_base_2d.gd"

# Hound Entity for 2D version
# This class implements the specific behavior for the Hound entity in 2D

# Entity-specific properties
@export var detection_range: float = 12.0
@export var attack_range: float = 2.0
@export var damage: float = 35.0
@export var speed: float = 4.0
@export var attack_cooldown: float = 1.0
@export var last_attack_time: float = 0.0
@export var patrol_points: Array[Vector2] = []
@export var current_patrol_index: int = 0
@export var is_patrolling: bool = true

# Animation and visual properties
@onready var animation_player = $AnimationPlayer

# Initialize the Hound entity
func _ready():
	# Call parent initialization
	super._ready()
	
	# Set entity-specific properties
	entity_type = "HOUND"
	max_health = 200.0
	health = max_health
	speed = 4.0
	detection_range = 12.0
	attack_range = 2.0
	damage = 35.0
	
	# Initialize patrol points
	patrol_points = [
		Vector2(-100, -100),
		Vector2(100, -100),
		Vector2(100, 100),
		Vector2(-100, 100)
	]
	current_patrol_index = 0
	
	# Connect signals
	connect("entity_damaged", self, "_on_entity_damaged")
	connect("entity_killed", self, "_on_entity_killed")

# Process function for behavior
func _process(delta):
	# Call parent process
	super._process(delta)
	
	if player != null and is_alive:
		var distance_to_player = get_distance_to_player()
		
		# If player is in detection range, start chasing
		if distance_to_player <= detection_range:
			chase_player(delta)
		# If player is close enough to attack, attack
		elif distance_to_player <= attack_range:
			attack_player(delta)
		# Otherwise, patrol
		else:
			patrol(delta)

# Chase the player
func chase_player(delta):
	if player == null:
		return
	
	var direction = (player.position - position).normalized()
	velocity = direction * speed
	
	# Apply movement
	move_and_slide()
	
	# Rotate to face player
	if direction != Vector2.ZERO:
		rotation = direction.angle_to(Vector2.RIGHT)

# Patrol around the level
func patrol(delta):
	if patrol_points.size() == 0:
		return
	
	# Move to next patrol point
	var target_point = patrol_points[current_patrol_index]
	var direction = (target_point - position).normalized()
	var distance_to_target = position.distance_to(target_point)
	
	velocity = direction * speed
	
	# Apply movement
	move_and_slide()
	
	# Rotate to face direction
	if direction != Vector2.ZERO:
		rotation = direction.angle_to(Vector2.RIGHT)
	
	# If reached target point, move to next
	if distance_to_target < 20:
		current_patrol_index = (current_patrol_index + 1) % patrol_points.size()

# Attack the player
func attack_player(delta):
	if player == null:
		return
	
	# Check if attack is on cooldown
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - last_attack_time < attack_cooldown:
		return
	
	# Perform attack
	last_attack_time = current_time
	player.take_damage(damage)
	
	# Play attack animation
	if animation_player.has_animation("attack"):
		animation_player.play("attack")

# Handle damage
func _on_entity_damaged(amount: float, new_health: float):
	# Play damage animation or effect
	if animation_player.has_animation("damage"):
		animation_player.play("damage")

# Handle death
func _on_entity_killed(entity):
	# Play death animation or effect
	if animation_player.has_animation("death"):
		animation_player.play("death")
	
	# Remove entity from game
	queue_free()