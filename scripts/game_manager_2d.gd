extends Node2D

# Game Manager for SCP Backrooms - 2D version
# Handles overall game flow, level transitions, and system coordination

# Game states
enum GameState {
	START_MENU,
	PLAYING,
	PAUSED,
	GAME_OVER,
	LEVEL_COMPLETE
}

# Game settings
@export var current_level: int = 1
@export var max_levels: int = 5
@export var game_state: int = GameState.START_MENU

# Game references
var player: Node2D = null
var entity_manager: Node2D = null
var entity_spawner: Node2D = null
var audio_system: Node2D = null
var particle_system: Node2D = null
var lighting_system: Node2D = null
var entity_interaction_system: Node2D = null
var ui_system: Node2D = null

# Level settings
var level_settings = {
	1: {
		"entity_types": ["smiler", "stalker"],
		"spawn_counts": [5, 3],
		"ambient_light": Color(0.4, 0.4, 0.4, 1.0),
		"atmosphere_density": 0.3
	},
	2: {
		"entity_types": ["smiler", "stalker", "hound"],
		"spawn_counts": [5, 3, 2],
		"ambient_light": Color(0.3, 0.3, 0.3, 1.0),
		"atmosphere_density": 0.5
	},
	3: {
		"entity_types": ["smiler", "stalker", "hound", "watcher"],
		"spawn_counts": [5, 3, 2, 1],
		"ambient_light": Color(0.2, 0.2, 0.2, 1.0),
		"atmosphere_density": 0.7
	},
	4: {
		"entity_types": ["smiler", "stalker", "hound", "watcher", "whisperer"],
		"spawn_counts": [5, 3, 2, 1, 1],
		"ambient_light": Color(0.15, 0.15, 0.15, 1.0),
		"atmosphere_density": 0.9
	},
	5: {
		"entity_types": ["smiler", "stalker", "hound", "watcher", "whisperer"],
		"spawn_counts": [5, 3, 2, 1, 1],
		"ambient_light": Color(0.1, 0.1, 0.1, 1.0),
		"atmosphere_density": 1.0
	}
}

# Signals
signal game_started()
signal game_paused()
signal game_resumed()
signal game_over()
signal level_loaded(level)
signal level_completed(level)
signal level_transitioning(to_level)

func _ready():
	# Initialize game manager
	add_to_group("game_manager")
	
	# Setup game state
	setup_game_state()
	
	# Connect signals
	connect_signals()

func setup_game_state():
	# Set initial game state
	game_state = GameState.START_MENU

func connect_signals():
	# Connect signals for game manager
	pass

func start_game():
	# Start the game
	game_state = GameState.PLAYING
	
	# Emit signal
	emit_signal("game_started")
	
	# Initialize game systems
	initialize_game_systems()
	
	# Load first level
	load_level(1)

func pause_game():
	# Pause the game
	if game_state == GameState.PLAYING:
		game_state = GameState.PAUSED
		
		# Emit signal
		emit_signal("game_paused")
		
		# Pause audio and systems
		pause_game_systems()

func resume_game():
	# Resume the game
	if game_state == GameState.PAUSED:
		game_state = GameState.PLAYING
		
		# Emit signal
		emit_signal("game_resumed")
		
		# Resume audio and systems
		resume_game_systems()

func game_over():
	# End the game
	game_state = GameState.GAME_OVER
	
	# Emit signal
	emit_signal("game_over")
	
	# Stop audio and systems
	stop_game_systems()

func load_level(level: int):
	# Load a specific level
	if level < 1 or level > max_levels:
		print("Invalid level: " + str(level))
		return
	
	# Set current level
	current_level = level
	
	# Emit signal
	emit_signal("level_loaded", level)
	
	# Load level
	prepare_level(level)

func prepare_level(level: int):
	# Prepare level settings
	if not level_settings.has(level):
		print("Level settings not found for level: " + str(level))
		return
	
	var settings = level_settings[level]
	
	# Update systems with level settings
	update_systems_with_level_settings(settings)
	
	# Spawn entities
	spawn_entities_for_level(level)

func update_systems_with_level_settings(settings: Dictionary):
	# Update lighting system
	if lighting_system != null:
		lighting_system.set_ambient_light(settings["ambient_light"])
		lighting_system.set_atmosphere_density(settings["atmosphere_density"])
	
	# Update particle system
	if particle_system != null:
		particle_system.set_atmosphere_intensity(settings["atmosphere_density"])

func spawn_entities_for_level(level: int):
	# Spawn entities for level
	if entity_spawner == null:
		print("Entity spawner not found")
		return
	
	if not level_settings.has(level):
		print("Level settings not found for level: " + str(level))
		return
	
	var settings = level_settings[level]
	var entity_types = settings["entity_types"]
	var spawn_counts = settings["spawn_counts"]
	
	# Spawn entities
	for i in range(len(entity_types)):
		var entity_type = entity_types[i]
		var count = spawn_counts[i]
		
		# Spawn entity
		entity_spawner.spawn_entities(entity_type, count)

func complete_level(level: int):
	# Complete current level
	if level != current_level:
		print("Trying to complete wrong level")
		return
	
	# Emit signal
	emit_signal("level_completed", level)
	
	# Move to next level or end game
	if level < max_levels:
		# Move to next level
		load_level(level + 1)
	else:
		# Game completed
		game_over()

func set_player(new_player: Node2D):
	player = new_player

func set_entity_manager(new_entity_manager: Node2D):
	entity_manager = new_entity_manager

func set_entity_spawner(new_entity_spawner: Node2D):
	entity_spawner = new_entity_spawner

func set_audio_system(new_audio_system: Node2D):
	audio_system = new_audio_system

func set_particle_system(new_particle_system: Node2D):
	particle_system = new_particle_system

func set_lighting_system(new_lighting_system: Node2D):
	lighting_system = new_lighting_system

func set_entity_interaction_system(new_interaction_system: Node2D):
	entity_interaction_system = new_interaction_system

func set_ui_system(new_ui_system: Node2D):
	ui_system = new_ui_system

func initialize_game_systems():
	# Initialize all game systems
	if audio_system != null:
		audio_system.set_game_manager(self)
	
	if particle_system != null:
		particle_system.set_game_manager(self)
	
	if lighting_system != null:
		lighting_system.set_game_manager(self)
	
	if entity_interaction_system != null:
		entity_interaction_system.set_game_manager(self)

func pause_game_systems():
	# Pause all game systems
	if audio_system != null:
		audio_system.pause()
	
	if particle_system != null:
		particle_system.pause_particles()
	
	if lighting_system != null:
		# No pause needed for lighting

func resume_game_systems():
	# Resume all game systems
	if audio_system != null:
		audio_system.resume()
	
	if particle_system != null:
		particle_system.resume_particles()
	
	if lighting_system != null:
		# No resume needed for lighting

func stop_game_systems():
	# Stop all game systems
	if audio_system != null:
		audio_system.stop()
	
	if particle_system != null:
		particle_system.stop_particles()
	
	if lighting_system != null:
		# No stop needed for lighting

func get_current_level() -> int:
	return current_level

func get_max_levels() -> int:
	return max_levels

func get_game_state() -> int:
	return game_state

func set_current_level(level: int):
	current_level = level

func set_max_levels(levels: int):
	max_levels = levels

func set_game_state(state: int):
	game_state = state

func get_player() -> Node2D:
	return player

func get_entity_manager() -> Node2D:
	return entity_manager

func get_entity_spawner() -> Node2D:
	return entity_spawner

func get_audio_system() -> Node2D:
	return audio_system

func get_particle_system() -> Node2D:
	return particle_system

func get_lighting_system() -> Node2D:
	return lighting_system

func get_entity_interaction_system() -> Node2D:
	return entity_interaction_system

func get_ui_system() -> Node2D:
	return ui_system

func set_game_manager(game_manager_ref: Node2D):
	# This is the game manager itself, so do nothing

func set_player_ref(player_ref: Node2D):
	player = player_ref

func set_entity_manager_ref(entity_manager_ref: Node2D):
	entity_manager = entity_manager_ref

func set_entity_spawner_ref(entity_spawner_ref: Node2D):
	entity_spawner = entity_spawner_ref

func set_audio_system_ref(audio_system_ref: Node2D):
	audio_system = audio_system_ref

func set_particle_system_ref(particle_system_ref: Node2D):
	particle_system = particle_system_ref

func set_lighting_system_ref(lighting_system_ref: Node2D):
	lighting_system = lighting_system_ref

func set_entity_interaction_system_ref(interaction_system_ref: Node2D):
	entity_interaction_system = interaction_system_ref

func set_ui_system_ref(ui_system_ref: Node2D):
	ui_system = ui_system_ref

func get_game_settings() -> Dictionary:
	# Get game settings
	return {
		"current_level": current_level,
		"max_levels": max_levels,
		"game_state": game_state
	}

func set_game_settings(settings: Dictionary):
	# Set game settings
	for key in settings.keys():
		match key:
			"current_level":
				current_level = settings[key]
			"max_levels":
				max_levels = settings[key]
			"game_state":
				game_state = settings[key]

func get_level_settings() -> Dictionary:
	# Get level settings
	return level_settings

func set_level_settings(settings: Dictionary):
	# Set level settings
	level_settings = settings

func get_level_setting(level: int, key: String):
	# Get specific level setting
	if not level_settings.has(level):
		return null
	
	if not level_settings[level].has(key):
		return null
	
	return level_settings[level][key]

func set_level_setting(level: int, key: String, value):
	# Set specific level setting
	if not level_settings.has(level):
		level_settings[level] = {}
	
	level_settings[level][key] = value

func start_game_flow():
	# Start full game flow
	start_game()

func pause_game_flow():
	# Pause game flow
	pause_game()

func resume_game_flow():
	# Resume game flow
	resume_game()

func game_over_flow():
	# Game over flow
	game_over()