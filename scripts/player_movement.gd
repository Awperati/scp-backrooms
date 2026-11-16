## Player movement component. WASD + sprint + jump.
extends Node3D

var walk_speed: float = 4.0
var sprint_speed: float = 8.0
var jump_velocity: float = 4.5
var is_sprinting: bool = false
var gravity_scale: float = 1.0

func get_parent_body() -> CharacterBody3D:
	return get_parent() as CharacterBody3D

func move(delta: float) -> void:
	var body = get_parent_body()
	if not body:
		return
	
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var forward = Vector3(direction.x, 0, direction.y)
	var right = get_camera_right()
	var move_dir = (forward * walk_speed + right * direction.x * walk_speed).normalized()
	
	if is_sprinting:
		var sprint_dir = (forward * sprint_speed + right * direction.x * sprint_speed).normalized()
		body.velocity.x = sprint_dir.x
		body.velocity.z = sprint_dir.z
	else:
		body.velocity.x = move_dir.x
		body.velocity.z = move_dir.z
	
	body.velocity.y -= 9.8 * gravity_scale * delta
	
	if body.is_on_floor() and Input.is_key_pressed(KEY_SPACE):
		body.velocity.y = jump_velocity
	
	body.move_and_slide()

func get_camera_right() -> Vector3:
	var body = get_parent_body()
	var camera = body.get_node("Camera") as Camera3D
	if camera:
		return camera.global_transform.basis.x.normalized()
	return Vector3.RIGHT
