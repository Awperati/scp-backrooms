extends Node2D

# Game Manager — game state, level progression, system coordination.

enum GameState { START_MENU, PLAYING, PAUSED, GAME_OVER, LEVEL_COMPLETE }

@export var current_level: int = 1
@export var max_levels: int = 5

var game_state: int = GameState.START_MENU

var player: Node2D = null
var entity_manager: Node2D = null
var entity_spawner: Node2D = null
var audio_system: Node = null
var particle_system: Node2D = null
var lighting_system: Node2D = null
var entity_interaction_system: Node2D = null
var ui_system: Control = null

var level_settings = {
	1: {"entity_types": ["smiler", "stalker"], "spawn_counts": [5, 3], "ambient_light": Color(0.4, 0.4, 0.4)},
	2: {"entity_types": ["smiler", "stalker", "hound"], "spawn_counts": [5, 3, 2], "ambient_light": Color(0.3, 0.3, 0.3)},
	3: {"entity_types": ["smiler", "stalker", "hound", "watcher"], "spawn_counts": [5, 3, 2, 1], "ambient_light": Color(0.2, 0.2, 0.2)},
	4: {"entity_types": ["smiler", "stalker", "hound", "watcher", "whisperer"], "spawn_counts": [5, 3, 2, 1, 1], "ambient_light": Color(0.15, 0.15, 0.15)},
	5: {"entity_types": ["smiler", "stalker", "hound", "watcher", "whisperer", "floating"], "spawn_counts": [5, 3, 2, 1, 1, 1], "ambient_light": Color(0.1, 0.1, 0.1)},
}

signal game_started()
signal game_paused()
signal game_resumed()
signal game_over()
signal level_loaded(level)
signal level_completed(level)

func _ready():
	add_to_group("game_manager")
	game_state = GameState.START_MENU

func start_game():
	game_state = GameState.PLAYING
	game_started.emit()
	initialize_game_systems()
	load_level(1)

func pause_game():
	if game_state != GameState.PLAYING:
		return
	game_state = GameState.PAUSED
	game_paused.emit()
	if audio_system != null and audio_system.has_method("pause_audio"):
		audio_system.pause_audio()

func resume_game():
	if game_state != GameState.PAUSED:
		return
	game_state = GameState.PLAYING
	game_resumed.emit()
	if audio_system != null and audio_system.has_method("resume_audio"):
		audio_system.resume_audio()

func do_game_over():
	game_state = GameState.GAME_OVER
	game_over.emit()

func load_level(level: int):
	if level < 1 or level > max_levels:
		return
	current_level = level
	level_loaded.emit(level)
	prepare_level(level)

func prepare_level(level: int):
	var settings = level_settings.get(level)
	if settings == null:
		return
	if lighting_system != null and lighting_system.has_method("set_ambient_light"):
		lighting_system.set_ambient_light(settings["ambient_light"])
	if entity_spawner != null:
		entity_spawner.set_current_level(level)
	# Spawn entities
	var entity_types = settings["entity_types"]
	var spawn_counts = settings["spawn_counts"]
	if entity_spawner != null:
		for i in range(entity_types.size()):
			entity_spawner.spawn_entities()
			break  # spawn_entities handles the count internally

func complete_level(level: int):
	if level != current_level:
		return
	level_completed.emit(level)
	if level < max_levels:
		load_level(level + 1)
	else:
		do_game_over()

func set_player(new_player: Node2D):
	player = new_player

func set_entity_manager(mgr: Node2D):
	entity_manager = mgr

func set_entity_spawner(spawner: Node2D):
	entity_spawner = spawner

func set_audio_system(sys: Node):
	audio_system = sys

func set_particle_system(sys: Node2D):
	particle_system = sys

func set_lighting_system(sys: Node2D):
	lighting_system = sys

func set_entity_interaction_system(sys: Node2D):
	entity_interaction_system = sys

func set_ui_system(sys: Control):
	ui_system = sys

func get_player() -> Node2D:
	return player

func initialize_game_systems():
	if entity_manager != null and entity_manager.has_method("set_game_manager"):
		entity_manager.set_game_manager(self)
	if entity_spawner != null:
		entity_spawner.set_game_manager(self)
	if entity_interaction_system != null:
		entity_interaction_system.set_game_manager(self)
		entity_interaction_system.set_player(player)
	if audio_system != null and audio_system.has_method("set_game_manager"):
		audio_system.set_game_manager(self)
	if lighting_system != null and lighting_system.has_method("set_game_manager"):
		lighting_system.set_game_manager(self)
