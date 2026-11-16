## Camera mouse look. Handles yaw (body) and pitch (camera).
extends Node3D

var sensitivity: float = 0.002

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var body = get_parent() as Node3D
		var camera = get_node("../Camera") as Camera3D
		if not body or not camera:
			return
		
		# Yaw: rotate player body on Y axis
		body.rotate_y(-event.relative.x * sensitivity)
		
		# Pitch: rotate camera on X axis, clamped
		var pitch = camera.rotation.x - event.relative.y * sensitivity
		pitch = clampf(pitch, deg_to_rad(-80.0), deg_to_rad(80.0))
		camera.rotation.x = pitch
