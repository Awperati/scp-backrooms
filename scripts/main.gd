extends Node

@onready var game_controller = $GameController
@onready var player = $Player
@onready var entity_manager = $EntityManager
@onready var entity_spawner = $EntitySpawner
@onready var audio_manager = $AudioManager
@onready var sanity_system = $SanitySystem
@onready var level_manager = $LevelManager

func _ready():
	# Initialize all game systems
	game_controller.initialize()
	entity_manager.initialize()
	entity_spawner.initialize()
	audio_manager.initialize()
	sanity_system.initialize()
	level_manager.initialize()
	
	# Start the game
	game_controller.start_game()

func _process(delta):
	# Update game systems
	game_controller.update(delta)
	entity_manager.update(delta)
	entity_spawner.update(delta)
	sanity_system.update(delta)
	
	# Handle game state changes
	if game_controller.game_state == "GAME_OVER":
		# Show game over screen
		TransitionManager.change_scene("res://scenes/game_over.tscn")
	elif game_controller.game_state == "VICTORY":
		# Show victory screen
		TransitionManager.change_scene("res://scenes/victory.tscn")
	elif game_controller.game_state == "TITLE":
		# Show title screen
		TransitionManager.change_scene("res://scenes/title_screen.tscn")