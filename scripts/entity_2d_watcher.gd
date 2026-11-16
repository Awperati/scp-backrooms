extends "res://scripts/entity_base_2d.gd"

# Watcher Entity for 2D version
# This class implements the specific behavior for the Watcher entity in 2D

# Entity-specific properties
@export var detection_range: float = 15.0
@export var attack_range: float = 3.0
@export var damage: float = 40.0
@export var speed: float = 2.5
@export var attack_cooldown: float = 3.0
@export var last_attack_time: float = 0.0
@export var is_visible: bool = false
@export var blink_timer: float = 0.0
@export var blink_interval: float = 2.0

# Animation and visual properties
@onready var animation_player = $AnimationPlayer

# Initialize the Watcher entity
func _ready():
	# Call parent initialization
	super._ready()
	
	# Set entity-specific properties
	entity_type = "WATCHER"
	max_health = 250.0
	health = max_health
	speed = 2.5
	detection_range = 15.0
	attack_range = 3.0
	damage = 40.0
	
	# Connect signals
	connect("entity_damaged", self, "_on_entity_damaged")
	connect("entity_killed", self, "_on_entity_killed")

# Process function for behavior
func _process(delta):
	# Call parent process
	super._process(delta)
	
	# Handle blinking behavior
	blink_timer += delta
	if blink_timer > blink_interval:
		is_visible = !is_visible
		blink_timer = 0.0
	
	# Set visibility based on blink state
	modulate.a = 0.0 if not is_visible else 1.0
	
	if player != null and is_alive:
		var distance_to_player = get_distance_to_player()
		
		# If player is in detection range, start pursuing
		if distance_to_player <= detection_range:
			pursue_player(delta)
		# If player is close enough to attack, attack
		elif distance_to_player <= attack_range:
			attack_player(delta)

# Pursue the player
func pursue_player(delta):
	if player == null:
		return
	
	var direction = (player.position - position).normalized()
	velocity = direction * speed
	
	# Apply movement
	move_and_slide()
	
	# Rotate to face player
	if direction != Vector2.ZERO:
		rotation = direction.angle_to(Vector2.RIGHT)

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