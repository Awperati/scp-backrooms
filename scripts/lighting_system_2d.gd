extends Node2D

# Lighting System for SCP Backrooms - 2D version
# Handles dynamic lighting, atmosphere, and visual effects

# Lighting settings
@export var ambient_light: Color = Color(0.2, 0.2, 0.2, 1.0)
@export var lighting_intensity: float = 1.0
@export var dynamic_lighting_enabled: bool = true

# Light sources
var light_sources = []

# Atmosphere settings
@export var atmosphere_density: float = 0.5
@export var fog_color: Color = Color(0.1, 0.1, 0.1, 0.8)
@export var fog_density: float = 0.3

# Game references
var game_manager: Node2D = null

# Signals
signal lighting_changed(intensity)
signal atmosphere_changed(density)

func _ready():
	# Initialize lighting system
	add_to_group("lighting_system")
	
	# Connect to game manager
	connect_to_game_manager()
	
	# Setup lighting
	setup_lighting()

func setup_lighting():
	# Create main light
	var main_light = DirectionalLight2D.new()
	main_light.name = "MainLight"
	main_light.light_color = Color(0.8, 0.8, 0.8, 1.0)
	main_light.light_energy = 0.5
	main_light.light_shadow_enabled = true
	main_light.cast_shadow = true
	add_child(main_light)
	
	# Create ambient light
	var ambient_light_node = Light2D.new()
	ambient_light_node.name = "AmbientLight"
	ambient_light_node.light_color = ambient_light
	ambient_light_node.light_energy = 0.3
	ambient_light_node.light_radius = 1000
	ambient_light_node.shadow_enabled = true
	add_child(ambient_light_node)
	
	# Add to light sources
	light_sources.append(main_light)
	light_sources.append(ambient_light_node)

func set_game_manager(new_game_manager: Node2D):
	game_manager = new_game_manager
	
	# Connect to game manager
	connect_to_game_manager()

func connect_to_game_manager():
	if game_manager != null:
		game_manager.connect("game_started", self, "on_game_started")
		game_manager.connect("game_paused", self, "on_game_paused")
		game_manager.connect("game_resumed", self, "on_game_resumed")
		game_manager.connect("game_over", self, "on_game_over")
		game_manager.connect("level_loaded", self, "on_level_loaded")
		game_manager.connect("level_completed", self, "on_level_completed")

func on_game_started():
	# Called when game starts
	# Start lighting effects
	pass

func on_game_paused():
	# Called when game pauses
	# Pause lighting effects
	pass

func on_game_resumed():
	# Called when game resumes
	# Resume lighting effects
	pass

func on_game_over():
	# Called when game ends
	# Set dark lighting
	set_lighting_intensity(0.1)

func on_level_loaded(level: int):
	# Called when level loads
	# Adjust lighting based on level
	match level:
		1:
			set_lighting_intensity(0.6)
			set_atmosphere_density(0.3)
		2:
			set_lighting_intensity(0.5)
			set_atmosphere_density(0.5)
		3:
			set_lighting_intensity(0.4)
			set_atmosphere_density(0.7)
		4:
			set_lighting_intensity(0.3)
			set_atmosphere_density(0.9)
		5:
			set_lighting_intensity(0.2)
			set_atmosphere_density(1.0)
	
	# Update lighting
	update_lighting()

func on_level_completed(level: int):
	# Called when level completes
	# Create level complete lighting effect
	pass

func set_lighting_intensity(intensity: float):
	# Set overall lighting intensity
	lighting_intensity = intensity
	
	# Update light sources
	update_light_sources()
	
	# Emit signal
	emit_signal("lighting_changed", intensity)

func update_light_sources():
	# Update all light sources based on intensity
	for light in light_sources:
		if light is DirectionalLight2D:
			# Update directional light
			light.light_energy = lighting_intensity * 0.5
		elif light is Light2D:
			# Update ambient light
			light.light_energy = lighting_intensity * 0.3

func update_lighting():
	# Update all lighting elements
	update_light_sources()

func set_atmosphere_density(density: float):
	# Set atmosphere density
	atmosphere_density = density
	
	# Update fog
	update_fog()
	
	# Emit signal
	emit_signal("atmosphere_changed", density)

func update_fog():
	# Update fog based on atmosphere density
	# This would affect the rendering
	
	# For now, just log it
	print("Atmosphere density: " + str(atmosphere_density))

func get_lighting_intensity() -> float:
	return lighting_intensity

func get_atmosphere_density() -> float:
	return atmosphere_density

func set_lighting_settings(settings: Dictionary):
	# Set lighting settings
	for key in settings.keys():
		match key:
			"ambient_light":
				ambient_light = settings[key]
				# Update ambient light node
				for light in light_sources:
					if light is Light2D:
						light.light_color = ambient_light
			"intensity":
				lighting_intensity = settings[key]
				update_light_sources()
			"dynamic_lighting":
				dynamic_lighting_enabled = settings[key]

func get_lighting_settings() -> Dictionary:
	# Get lighting settings
	return {
		"ambient_light": ambient_light,
		"intensity": lighting_intensity,
		"dynamic_lighting": dynamic_lighting_enabled
	}

func get_atmosphere_settings() -> Dictionary:
	# Get atmosphere settings
	return {
		"density": atmosphere_density,
		"fog_color": fog_color,
		"fog_density": fog_density
	}

func set_atmosphere_settings(settings: Dictionary):
	# Set atmosphere settings
	for key in settings.keys():
		match key:
			"density":
				atmosphere_density = settings[key]
			"fog_color":
				fog_color = settings[key]
			"fog_density":
				fog_density = settings[key]

func get_light_sources() -> Array:
	return light_sources

func set_light_sources(sources: Array):
	light_sources = sources

func add_light_source(light: Light2D):
	# Add a new light source
	light_sources.append(light)
	add_child(light)

func remove_light_source(light: Light2D):
	# Remove a light source
	light_sources.erase(light)
	remove_child(light)

func get_ambient_light() -> Color:
	return ambient_light

func set_ambient_light(color: Color):
	# Set ambient light color
	ambient_light = color
	
	# Update ambient light node
	for light in light_sources:
		if light is Light2D:
			light.light_color = ambient_light

func set_dynamic_lighting(enabled: bool):
	# Enable or disable dynamic lighting
	dynamic_lighting_enabled = enabled
	
	# Update lighting
	update_lighting()