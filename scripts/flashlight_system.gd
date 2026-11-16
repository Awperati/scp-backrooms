extends Node

# Flashlight System for SCP Backrooms game
# Handles player flashlight functionality and effects

# Flashlight properties
@export var light_range: float = 15.0
@export var light_energy: float = 2.0
@export var light_color: Color = Color(1, 1, 0.8)
@export var light_angle: float = 45.0

# References
var player: Node = null
var flashlight_light: OmniLight = null
var flashlight_projector: Projector = null

func _ready():
	# Initialize flashlight
	setup_flashlight()
	
	# Find player
	player = get_tree().get_nodes_in_group("player")[0] if get_tree().get_nodes_in_group("player").size() > 0 else null
	
	# Connect to player events
	if player != null:
		player.connect("flashlight_toggled", self, "toggle_flashlight")

func setup_flashlight():
	# Setup flashlight light
	flashlight_light = $FlashlightLight
	if flashlight_light != null:
		flashlight_light.range = light_range
		flashlight_light.energy = light_energy
		flashlight_light.light_color = light_color
		flashlight_light.omni_angle = light_angle
	
	# Setup flashlight projector
	flashlight_projector = $FlashlightProjector
	if flashlight_projector != null:
		flashlight_projector.projector = preload("res://assets/textures/flashlight_projector.png")

func toggle_flashlight():
	# Toggle flashlight on/off
	if flashlight_light != null:
		flashlight_light.visible = !flashlight_light.visible
	
	if flashlight_projector != null:
		flashlight_projector.visible = !flashlight_projector.visible

func update_flashlight():
	# Update flashlight based on player state
	if flashlight_light != null:
		# Adjust intensity based on sanity
		if player != null and player.sanity != null:
			if player.sanity < 30:
				flashlight_light.energy = light_energy * 0.5
			else:
				flashlight_light.energy = light_energy

func set_flashlight_intensity(intensity: float):
	# Set flashlight intensity
	if flashlight_light != null:
		flashlight_light.energy = intensity

func set_flashlight_color(color: Color):
	# Set flashlight color
	if flashlight_light != null:
		flashlight_light.light_color = color

func get_flashlight_status():
	# Return flashlight status
	if flashlight_light != null:
		return flashlight_light.visible
	return false