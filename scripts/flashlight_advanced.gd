extends Node3D

# Advanced flashlight system for SCP Backrooms
# Provides better lighting with dynamic effects

@export var light_range: float = 10.0
@export var light_intensity: float = 2.0
@export var cone_angle: float = 45.0
@export var emission_intensity: float = 0.5

# References
var light: OmniLight3D = null
var light_visual: MeshInstance3D = null

func _ready():
	# Setup flashlight
	light = get_node("Light3D") if get_node("Light3D") != null else null
	light_visual = get_node("MeshInstance3D") if get_node("MeshInstance3D") != null else null
	
	# Configure light if exists
	if light != null:
		light.light_range = light_range
		light.light_intensity = light_intensity
		light.light_cone_angle = cone_angle
		light.shadow_enabled = true
	
	# Set emission for visual effect
	if light_visual != null:
		light_visual.get_surface_material(0).emission_energy = emission_intensity

func set_emission_intensity(intensity: float):
	# Update emission for visual feedback
	if light_visual != null:
		light_visual.get_surface_material(0).emission_energy = intensity
	
	# Update light emission too
	if light != null:
		light.light_energy = intensity * 2.0

func set_light_range(range: float):
	# Update light range
	if light != null:
		light.light_range = range

func set_light_intensity(intensity: float):
	# Update light intensity
	if light != null:
		light.light_intensity = intensity