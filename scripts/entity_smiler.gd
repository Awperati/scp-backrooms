## Smiler entity. Appears in darkness, attacks when flashlight is off.
extends Node3D

var detection_radius: float = 3.0
var flashlight_off_time: float = 0.0
var is_visible: bool = false

func _ready() -> void:
	$Sprite2D.billboard = GeometryInstance3D.BILLBOARD_ENABLED
	$Sprite2D.material_override = SpatialMaterial.new()
	$Sprite2D.material_override.albedo_color = Color.WHITE
	$Sprite2D.material_override.emissive = Color.WHITE
	$Sprite2D.material_override.emissive_multiplier = 2.0
	visible = false

func _process(delta: float) -> void:
	var player = get_node("/root/Game/Player") as Node3D
	if not player:
		return
	
	var dist = global_position.distance_to(player.global_position)
	var flashlight = player.get_node("Body/PlayerFlashlight")
	var flashlight_on = flashlight.flashlight_on if flashlight else true
	
	if dist <= detection_radius and not flashlight_on:
		flashlight_off_time += delta
		if flashlight_off_time >= 2.0:
			# Attack!
			GameController.lose_sanity(50.0)
			flashlight_off_time = 0.0
	elif dist <= detection_radius and flashlight_on:
		flashlight_off_time = 0.0
		is_visible = true
		visible = true
	else:
		flashlight_off_time = 0.0
		is_visible = false
		visible = false
