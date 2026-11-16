extends CharacterBody3D

# Player configuration
@export var move_speed: float = 5.0
@export var jump_velocity: float = 10.0
@export var gravity: float = 9.8

# Player state
var is_jumping: bool = false
var health: float = 100.0
var sanity: float = 100.0

# Input
var direction: Vector3 = Vector3.ZERO
var velocity: Vector3 = Vector3.ZERO

# Game references
var game_controller: Node = null

func _ready():
	# Initialize player
	game_controller = get_tree().get_nodes_in_group("game_controller")[0] if get_tree().get_nodes_in_group("game_controller").size() > 0 else null
	health = 100.0
	sanity = 100.0

func _process(delta):
	# Handle movement
	handle_movement(delta)
	
	# Update sanity (decreases over time)
	sanity = max(sanity - delta * 0.5, 0)

func handle_movement(delta):
	# Get input
	direction = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_backward"):
		direction.z += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		is_jumping = true
	
	# Normalize direction
	direction = direction.normalized()
	
	# Apply movement
	velocity.x = direction.x * move_speed
	velocity.z = direction.z * move_speed
	
	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0
	
	# Move player
	move_and_slide()

func take_damage(amount: float):
	health -= amount
	if health <= 0:
		health = 0
		if game_controller != null:
			game_controller.game_over()

func restore_health(amount: float):
	health = min(health + amount, 100.0)

func reduce_sanity(amount: float):
	sanity -= amount
	if sanity <= 0:
		sanity = 0
		if game_controller != null:
			game_controller.game_over()

func restore_sanity(amount: float):
	sanity = min(sanity + amount, 100.0)

func get_sanity_percentage():
	return sanity / 100.0