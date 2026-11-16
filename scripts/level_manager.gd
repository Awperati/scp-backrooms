extends Node

# Level management
@export var level_name: String = "Level 0"
@export var required_drives: int = 2
@export var level_index: int = 0

# Game references
var game_controller: Node = null
var player: Node3D = null

func initialize():
	# Setup level manager
	game_controller = get_tree().get_nodes_in_group("game_controller")[0] if get_tree().get_nodes_in_group("game_controller").size() > 0 else null
	player = get_tree().get_nodes_in_group("player")[0] if get_tree().get_nodes_in_group("player").size() > 0 else null

func update(delta):
	# Check level completion
	if game_controller != null and game_controller.collected_drives >= required_drives:
		complete_level()

func complete_level():
	# Level complete logic
	if game_controller != null:
		game_controller.victory()