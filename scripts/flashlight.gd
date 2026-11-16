extends Node3D

# Flashlight configuration
@export var light_range: float = 10.0
@export var light_energy: float = 2.0
@export var battery_level: float = 100.0

# References
var player: Node3D = null
var light: OmniLight3D = null
var game_controller: Node = null

func _ready():
	# Setup flashlight
	light = $Light
	player = get_parent()
	game_controller = get_tree().get_nodes_in_group("game_controller")[0] if get_tree().get_nodes_in_group("game_controller").size() > 0 else null
	
	# Configure light
	light.range = light_range
	light.energy = light_energy

func _process(delta):
	# Update flashlight with player position
	if player != null:
		position = player.position + Vector3(0, 0.5, 0.5)
	
	# Consume battery
	battery_level -= delta * 0.5
	if battery_level <= 0:
		battery_level = 0
		light.energy = 0
	else:
		light.energy = light_energy * (battery_level / 100.0)

func restore_battery(amount: float):
	battery_level = min(battery_level + amount, 100.0)