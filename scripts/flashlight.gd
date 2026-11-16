extends Node2D

# Flashlight system for the SCP Backrooms game

var light_enabled = true
var light_radius = 5.0
var light_energy = 1.0
var battery_level = 100.0
var max_battery = 100.0

func _ready():
	# Initialize the flashlight
	$Light2D.enabled = light_enabled
	$Light2D.radius = light_radius
	$Light2D.energy = light_energy
	
	# Start battery drain
	set_process(true)

func _process(delta):
	# Drain battery over time
	if light_enabled:
		battery_level -= 0.1 * delta
		battery_level = clamp(battery_level, 0, max_battery)
		
		# Update light energy based on battery
		if battery_level > 0:
			$Light2D.energy = light_energy * (battery_level / max_battery)
		else:
			$Light2D.energy = 0.0

func toggle_light():
	# Toggle flashlight on/off
	light_enabled = !light_enabled
	$Light2D.enabled = light_enabled

func set_light_radius(radius):
	# Set flashlight radius
	light_radius = radius
	$Light2D.radius = light_radius

func set_light_energy(energy):
	# Set flashlight energy
	light_energy = energy
	$Light2D.energy = light_energy

func charge_battery(amount):
	# Charge the flashlight battery
	battery_level += amount
	battery_level = clamp(battery_level, 0, max_battery)

func get_battery_level():
	# Get current battery level
	return battery_level

func is_light_on():
	# Check if light is on
	return light_enabled