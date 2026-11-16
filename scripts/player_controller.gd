## Player controller for movement and interaction
extends CharacterBody3D

# Player properties
@export var movement_speed: float = 5.0
@export var run_speed: float = 10.0
@export var jump_force: float = 10.0
@export var gravity: float = -9.8
@export var player_height: float = 1.8

# Player state
var is_running: bool = false
var is_jumping: bool = false
var is_sanity_degrading: bool = false

# References to game components
var game_controller: Node
var camera: Camera3D

func _ready() -> void:
	# Get references to game controller
	game_controller = get_tree().get_first_node_in_group("game_controller")
	
	# Get camera reference
	camera = get_node("Camera3D")
	
	# Setup input actions
	Input.set_action_repeat("forward", 0.01)

func _process(delta: float) -> void:
	# Update player state
	update_player_state(delta)

func _physics_process(delta: float) -> void:
	# Handle movement physics
	handle_movement(delta)

func update_player_state(delta: float) -> void:
	# Update sanity degrading if needed
	if is_sanity_degrading:
		# Gradually decrease sanity
		if game_controller:
			game_controller.update_sanity(-delta * 0.05)

func handle_movement(delta: float) -> void:
	# Handle player movement
	var direction = Vector3.ZERO
	
	# Get input
	if Input.is_action_pressed("forward"):
		direction += -transform.basis.z
	if Input.is_action_pressed("backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("left"):
		direction += -transform.basis.x
	if Input.is_action_pressed("right"):
		direction += transform.basis.x
	
	# Normalize direction
	direction = direction.normalized()
	
	# Apply movement
	velocity.x = direction.x * movement_speed
	velocity.z = direction.z * movement_speed
	
	# Handle running
	if Input.is_action_pressed("run"):
		is_running = true
		velocity.x *= run_speed / movement_speed
		velocity.z *= run_speed / movement_speed
	else:
		is_running = false
	
	# Handle jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
	
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity
	
	# Move the player
	move_and_slide()

func _on_player_damaged(amount: int) -> void:
	# Handle player taking damage
	pass

func _on_sanity_changed(new_sanity: float) -> void:
	# Handle sanity change
	if new_sanity < 0.3:
		# Player is in danger
		is_sanity_degrading = true
	else:
		is_sanity_degrading = false

# Signals
signal player_damaged
signal sanity_changed