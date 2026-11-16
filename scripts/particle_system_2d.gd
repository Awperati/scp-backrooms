extends Node2D

# Particle System for SCP Backrooms - 2D version
# Handles particle effects and atmospheric visuals

# Particle settings
@export var particle_lifetime: float = 2.0
@export var particle_speed: float = 50.0
@export var particle_count: int = 100

# Game references
var game_manager: Node2D = null
var player: Node2D = null

# Particle emitters
var particle_emitters = []

# Atmosphere settings
@export var atmosphere_intensity: float = 1.0
@export var ambient_light: Color = Color(0.2, 0.2, 0.2, 1.0)

# Signals
signal particle_emitted(particle_type)
signal atmosphere_changed(intensity)

func _ready():
	# Initialize particle system
	add_to_group("particle_system")
	
	# Connect to game manager
	connect_to_game_manager()
	
	# Setup particle emitters
	setup_particle_emitters()

func setup_particle_emitters():
	# Create particle emitters
	for i in range(3):
		var emitter = Particle2D.new()
		emitter.name = "ParticleEmitter" + str(i)
		emitter.texture = preload("res://textures/particle.png")
		add_child(emitter)
		particle_emitters.append(emitter)

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
	start_particles()

func on_game_paused():
	# Called when game pauses
	pause_particles()

func on_game_resumed():
	# Called when game resumes
	resume_particles()

func on_game_over():
	# Called when game ends
	stop_particles()

func on_level_loaded(level: int):
	# Called when level loads
	# Adjust particle effects based on level
	pass

func on_level_completed(level: int):
	# Called when level completes
	# Create level complete particles
	emit_particles("level_complete", 50)

func set_player(new_player: Node2D):
	player = new_player

func _process(delta):
	# Update particle emitters
	update_particle_emitters(delta)

func update_particle_emitters(delta: float):
	# Update all particle emitters
	for emitter in particle_emitters:
		if emitter is Particle2D:
			# Update emitter
			pass

func start_particles():
	# Start all particle effects
	for emitter in particle_emitters:
		if emitter is Particle2D:
			# Start emitter
			pass

func pause_particles():
	# Pause all particle effects
	for emitter in particle_emitters:
		if emitter is Particle2D:
			# Pause emitter
			pass

func resume_particles():
	# Resume all particle effects
	for emitter in particle_emitters:
		if emitter is Particle2D:
			# Resume emitter
			pass

func stop_particles():
	# Stop all particle effects
	for emitter in particle_emitters:
		if emitter is Particle2D:
			# Stop emitter
			pass

func emit_particles(particle_type: String, count: int = 10):
	# Emit particles of given type
	for i in range(count):
		# Create particle
		var particle = Particle2D.new()
		particle.texture = preload("res://textures/particle.png")
		
		# Set position
		if player != null:
			particle.position = player.position + Vector2(randf() * 50 - 25, randf() * 50 - 25)
		else:
			particle.position = Vector2(randf() * 400, randf() * 300)
		
		# Set properties
		particle.lifetime = particle_lifetime
		particle.speed = particle_speed
		
		# Add to scene
		add_child(particle)
		
		# Emit signal
		emit_signal("particle_emitted", particle_type)
	
	# Emit signal
	emit_signal("particle_emitted", particle_type)

func set_atmosphere_intensity(intensity: float):
	# Set atmosphere intensity
	atmosphere_intensity = intensity
	
	# Update ambient light
	update_ambient_light()
	
	# Emit signal
	emit_signal("atmosphere_changed", intensity)

func update_ambient_light():
	# Update ambient light based on atmosphere intensity
	# This would affect the lighting system
	
	# For now, just log it
	print("Atmosphere intensity: " + str(atmosphere_intensity))

func get_atmosphere_intensity() -> float:
	return atmosphere_intensity

func get_ambient_light() -> Color:
	return ambient_light

func set_atmosphere_settings(settings: Dictionary):
	# Set atmosphere settings
	for key in settings.keys():
		match key:
			"intensity":
				atmosphere_intensity = settings[key]
			"ambient_light":
				ambient_light = settings[key]

func get_atmosphere_settings() -> Dictionary:
	# Get atmosphere settings
	return {
		"intensity": atmosphere_intensity,
		"ambient_light": ambient_light
	}

func get_particle_emitters() -> Array:
	return particle_emitters

func set_particle_emitters(emitters: Array):
	particle_emitters = emitters

func get_particle_lifetime() -> float:
	return particle_lifetime

func set_particle_lifetime(lifetime: float):
	particle_lifetime = lifetime

func get_particle_speed() -> float:
	return particle_speed

func set_particle_speed(speed: float):
	particle_speed = speed

func get_particle_count() -> int:
	return particle_count

func set_particle_count(count: int):
	particle_count = count