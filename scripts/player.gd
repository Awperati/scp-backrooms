## Main player controller. Ties movement, camera, flashlight, sanity together.
extends Node3D

@export var walk_speed: float = 4.0
@export var sprint_speed: float = 8.0
@export var jump_velocity: float = 4.5

var is_sprinting: bool = false
var flashlight_on: bool = true
var sanity_visible: bool = true
var footstep_timer: float = 0.0
var footstep_interval: float = 0.5

var player_movement: Node
var player_camera: Node
var player_flashlight: Node
var sanity_system: Node

func _ready() -> void:
	add_to_group("player")
	
	player_movement = $Body.get_node("PlayerMovement")
	player_camera = $Body.get_node("PlayerCamera")
	player_flashlight = $Body.get_node("PlayerFlashlight")
	sanity_system = $Body.get_node("SanitySystem")
	
	player_movement.walk_speed = walk_speed
	player_movement.sprint_speed = sprint_speed
	player_movement.jump_velocity = jump_velocity
	
	if player_flashlight:
		player_flashlight.flashlight_on = flashlight_on
		player_flashlight.enabled = true
	
	# Position at spawn point in level
	var game = get_node("/root/Game")
	if game:
		var spawn = game.get_node("Level/PlayerSpawn")
		if spawn:
			global_position = spawn.global_position

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_F:
				flashlight_on = !flashlight_on
				if player_flashlight:
					player_flashlight.flashlight_on = flashlight_on
			if event.keycode == KEY_ESCAPE:
				get_viewport().set_input_as_handled()

func _process(delta: float) -> void:
	is_sprinting = Input.is_key_pressed(KEY_SHIFT)
	player_movement.is_sprinting = is_sprinting
	
	# Footstep sounds
	if is_on_floor():
		var speed = linear_speed
		if speed > 0.5:
			footstep_timer += delta
			if footstep_timer >= footstep_interval:
				footstep_timer = 0.0
				_play_footstep()

func _play_footstep() -> void:
	var variant = randi() % 4 + 1
	var audio = $Body/FootstepSound
	if audio and audio.stream:
		audio.play()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		apply_gravity()
	player_movement.move(delta)

func _on_sanity_changed(value: float) -> void:
	if sanity_system:
		sanity_system.current_sanity = value
