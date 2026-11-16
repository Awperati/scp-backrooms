## Flashlight for player to illuminate the dark
extends Node3D

# Flashlight properties
@export var light_intensity: float = 1.0
@export var light_range: float = 10.0
@export var battery_level: float = 1.0
@export var battery_drain_rate: float = 0.01
@export var battery_recharge_rate: float = 0.005

# References to game components
var game_controller: Node
var player: Node3D
var flashlight_light: OmniLight

func _ready() -> void:
	# Get references to game controller
	game_controller = get_tree().get_first_node_in_group("game_controller")
	
	# Get player reference
	player = get_tree().get_first_node_in_group("player")
	
	# Get flashlight light node
	flashlight_light = get_node("FlashlightLight")
	
	# Setup signals
	if game_controller:
		game_controller.connect("game_started", self, "_on_game_started")
		game_controller.connect("game_over", self, "_on_game_over")
		game_controller.connect("victory", self, "_on_victory")

func _process(delta: float) -> void:
	# Update flashlight battery
	if game_controller.current_state == GameController.GameState.PLAYING:
		update_flashlight_battery(delta)

func _on_game_started() -> void:
	# Start flashlight when game starts
	battery_level = 1.0

func _on_game_over() -> void:
	# Turn off flashlight when game is over
	battery_level = 0.0

func _on_victory() -> void:
	# Turn off flashlight when player wins
	battery_level = 0.0

func update_flashlight_battery(delta: float) -> void:
	# Drain battery when flashlight is on
	if battery_level > 0:
		battery_level -= battery_drain_rate * delta
		battery_level = clamp(battery_level, 0.0, 1.0)
	
	# Recharge when not in use
	if battery_level < 1.0:
		battery_level += battery_recharge_rate * delta
		battery_level = clamp(battery_level, 0.0, 1.0)
	
	# Update light intensity
	if flashlight_light:
		flashlight_light.energy = battery_level * light_intensity

func _on_battery_empty() -> void:
	# Handle battery depletion
	print("Flashlight battery depleted")

func _on_battery_recharged() -> void:
	# Handle battery recharging
	print("Flashlight battery recharged")