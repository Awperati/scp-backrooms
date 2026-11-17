## Flashlight toggle, battery, flicker effect.
## Toggle with F.
extends Node3D

@export var toggle_key: Key = KEY_F

var flashlight_on: bool = true
var enabled: bool = true
var battery: float = 100.0
var battery_drain: float = 10.0
var flicker_intensity: float = 0.3
var flicker_speed: float = 5.0

var original_energy: float = 3.0

func _ready() -> void:
	var light = get_node("../Flashlight") as SpotLight3D
	if light:
		original_energy = light.light_energy

func _process(delta: float) -> void:
	var light = get_node("../Flashlight") as SpotLight3D
	if not light:
		return
	
	if not enabled:
		light.visible = false
		return
	
	light.visible = flashlight_on
	if not flashlight_on:
		return
	
	# Battery drain
	battery -= battery_drain * delta
	if battery <= 0.0:
		battery = 0.0
		flashlight_on = false
		light.visible = false
		return
	
	# Low battery flicker
	if battery < 20.0:
		var noise = randf()
		if noise < 0.3:
			light.light_energy = original_energy * 0.3
		else:
			light.light_energy = original_energy
	else:
		# Sanity-based flicker
		var sanity = GameController.sanity
		if sanity < 30.0:
			var t = Time.get_ticks_msec() / 1000.0
			var flicker = 1.0 - abs(sin(t * flicker_speed)) * flicker_intensity
			light.light_energy = original_energy * flicker
		else:
			light.light_energy = original_energy

func toggle() -> void:
	flashlight_on = not flashlight_on
	if flashlight_on and battery > 0:
		var light = get_node("../Flashlight") as SpotLight3D
		if light:
			light.visible = true

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == toggle_key:
			toggle()
