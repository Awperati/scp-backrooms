extends Node

# Main game entry point — wires all systems together.

var game_manager: Node = null
var player: Node2D = null
var level: Node2D = null
var entity_spawner: Node2D = null
var entity_interaction_system: Node2D = null
var ui_system: Control = null
var audio_system: Node = null
var particle_system: Node2D = null
var lighting_system: Node2D = null

func _ready():
	_find_nodes()
	_wire_systems()
	start_game()

func _find_nodes():
	var children = get_children()
	for child in children:
		if child.name == "Level":
			level = child
		elif child.name == "Player":
			player = child
		elif child.name == "GameManager":
			game_manager = child
		elif child.name == "EntityInteractionSystem":
			entity_interaction_system = child
		elif child.name == "UISystem":
			ui_system = child
		elif child.name == "AudioSystem":
			audio_system = child
		elif child.name == "ParticleSystem":
			particle_system = child
		elif child.name == "LightingSystem":
			lighting_system = child
	# Find spawner and entity manager inside the level
	if level != null:
		for child in level.get_children():
			if child.name == "EntitySpawner":
				entity_spawner = child
			if child.is_in_group("data_drive") or child.is_in_group("exit_door"):
				pass  # handled by level manager

func _wire_systems():
	if game_manager == null:
		return
	game_manager.set_player(player)
	game_manager.set_entity_spawner(entity_spawner)
	game_manager.set_entity_interaction_system(entity_interaction_system)
	game_manager.set_ui_system(ui_system)
	game_manager.set_audio_system(audio_system)
	game_manager.set_particle_system(particle_system)
	game_manager.set_lighting_system(lighting_system)

	if entity_spawner != null:
		entity_spawner.set_game_manager(game_manager)

	if entity_interaction_system != null:
		entity_interaction_system.set_game_manager(game_manager)
		entity_interaction_system.set_player(player)

	if level != null and level.has_method("set_game_manager"):
		level.set_game_manager(game_manager)

func start_game():
	if game_manager != null:
		game_manager.start_game()
