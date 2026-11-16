extends CharacterBody3D

# Player Controller for SCP Backrooms game
# Handles player movement, actions, and visual effects

# Movement properties
@export var walk_speed: float = 5.0
@export var run_speed: float = 8.0
@export var jump_velocity: float = 4.5
@export var gravity: float = -9.8

# Player stats
var health: float = 100.0
var sanity: float = 100.0
var is_running: bool = false
var is_sprinting: bool = false

# References
@onready var camera: Camera3D = null
@onready var audio_manager: Node = null
@onready var ui_manager: Node = null
@onready var model: Node3D = null
@onready var flashlight: Node = null
@onready var footsteps_particles: Particles3D = null
@onready var damage_flash: Sprite3D = null

# Animation
@onready var animation_player: AnimationPlayer = null

func _ready():
	# Initialize references
	camera = $Camera3D
	model = $Model
	flashlight = $Flashlight
	footsteps_particles = $FootstepParticles
	damage_flash = $DamageFlash
	
	# Setup animation player
	animation_player = $AnimationPlayer
	if animation_player != null:
		animation_player.play("idle")
	
	# Connect to signals
	connect_signals()
	
	# Find audio manager and UI manager in the tree
	var audio_nodes = get_tree().get_nodes_in_group("audio_manager")
	if audio_nodes.size() > 0:
		audio_manager = audio_nodes[0]
	
	var ui_nodes = get_tree().get_nodes_in_group("ui_manager")
	if ui_nodes.size() > 0:
		ui_manager = ui_nodes[0]

func connect_signals():
	# Connect signals
	pass

func _physics_process(delta):
	# Handle movement
	handle_movement(delta)
	
	# Update UI
	update_ui()
	
	# Handle flashlight
	if flashlight != null:
		flashlight.rotation.x = deg_to_rad(-camera.rotation.x)

func handle_movement(delta):
	var direction = Vector3.ZERO
	
	# Get input
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_backward"):
		direction.z += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	
	# Normalize direction
	if direction.length() > 0:
		direction = direction.normalized()
	
	# Apply movement
	var speed = walk_speed
	if Input.is_action_pressed("run") and not is_sprinting:
		is_sprinting = true
		speed = run_speed
	elif not Input.is_action_pressed("run") and is_sprinting:
		is_sprinting = false
		speed = walk_speed
	
	# Apply movement
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	# Handle jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		if audio_manager != null:
			audio_manager.play_jump_sound()
	
	# Apply gravity
	velocity.y += gravity
	
	# Move player
	move_and_slide()

func update_ui():
	# Update UI with player stats
	if ui_manager != null:
		ui_manager.update_health(health)
		ui_manager.update_sanity(sanity)

func take_damage(amount: float):
	health -= amount
	if health <= 0:
		health = 0
		game_over()
	else:
		# Visual feedback
		if damage_flash != null:
			damage_flash.visible = true
			await get_tree().create_timer(0.1).timeout
			damage_flash.visible = false
		
		# Play sound
		if audio_manager != null:
			audio_manager.play_damage_sound()
	
	# Update UI
	update_ui()

func lose_sanity(amount: float):
	sanity -= amount
	if sanity <= 0:
		sanity = 0
		game_over()
	else:
		# Play sound
		if audio_manager != null:
			audio_manager.play_sanity_loss_sound()
	
	# Update UI
	update_ui()

func game_over():
	# Handle game over
	if ui_manager != null:
		ui_manager.show_message("GAME OVER", 5.0)
	
	# Disable player controls
	monitoring = false
	physics_process_mode = PhysicsProcessModeEnum.DISABLED

func gain_sanity(amount: float):
	sanity = min(sanity + amount, 100.0)
	update_ui()

func gain_health(amount: float):
	health = min(health + amount, 100.0)
	update_ui()

func toggle_flashlight():
	if flashlight != null:
		flashlight.visible = !flashlight.visible

func play_footstep():
	if footsteps_particles != null:
		footsteps_particles.emitting = true
		await get_tree().create_timer(0.1).timeout
		footsteps_particles.emitting = false
	
	# Play sound
	if audio_manager != null:
		audio_manager.play_footstep_sound()