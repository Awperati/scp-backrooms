extends Node2D

# Lighting System — ambient light, dynamic lighting, flicker.

@export var ambient_light: Color = Color(0.2, 0.2, 0.2, 1.0)
@export var lighting_intensity: float = 1.0
@export var atmosphere_density: float = 0.5
@export var flicker_speed: float = 2.0

var game_manager: Node2D = null
var flicker_timer: float = 0.0
var is_flickering: bool = false

var ambient_light_node: Light2D = null
var canvas_modulate: CanvasModulate = null

signal lighting_changed(intensity)
signal atmosphere_changed(density)

func _ready():
	add_to_group("lighting_system")
	_create_lighting()

func _create_lighting():
	# Canvas modulate for global color
	canvas_modulate = CanvasModulate.new()
	canvas_modulate.name = "CanvasModulate"
	canvas_modulate.color = Color(1.0, 1.0, 1.0, 1.0)
	canvas_modulate.blend_mode = CanvasModulate.BLEND_MODE_MULTIPLY
	# Add to parent so it affects everything
	if get_parent() != null:
		get_parent().add_child(canvas_modulate)

	# Ambient light
	ambient_light_node = Light2D.new()
	ambient_light_node.name = "AmbientLight"
	ambient_light_node.light_color = ambient_light
	ambient_light_node.light_energy = 0.5
	add_child(ambient_light_node)

func _process(delta):
	if is_flickering:
		flicker_timer += delta * flicker_speed
		var flicker = sin(flicker_timer * 10.0) * 0.2 + 0.8
		if ambient_light_node:
			ambient_light_node.light_energy = 0.5 * flicker * lighting_intensity
		if canvas_modulate:
			canvas_modulate.color = Color(1.0, 1.0, 1.0, atmosphere_density * flicker)

func set_game_manager(mgr: Node2D):
	game_manager = mgr

func set_ambient_light(color: Color):
	ambient_light = color
	if ambient_light_node:
		ambient_light_node.light_color = color
	lighting_changed.emit(lighting_intensity)

func set_lighting_intensity(v: float):
	lighting_intensity = v
	if ambient_light_node:
		ambient_light_node.light_energy = 0.5 * v
	lighting_changed.emit(v)

func set_atmosphere_density(v: float):
	atmosphere_density = v
	if canvas_modulate:
		canvas_modulate.color = Color(1.0, 1.0, 1.0, v)
	atmosphere_changed.emit(v)

func start_flicker():
	is_flickering = true
	flicker_timer = 0.0

func stop_flicker():
	is_flickering = false
	if ambient_light_node:
		ambient_light_node.light_energy = 0.5 * lighting_intensity
	if canvas_modulate:
		canvas_modulate.color = Color(1.0, 1.0, 1.0, atmosphere_density)
