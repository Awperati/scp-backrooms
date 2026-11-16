extends Node3D

# Exit door properties
@export var door_id: String = "exit_door_001"
@export var required_drives: int = 3
@export var unlocked: bool = false

# Game references
var game_controller: Node = null

func _ready():
	# Setup exit door
	game_controller = get_tree().get_nodes_in_group("game_controller")[0] if get_tree().get_nodes_in_group("game_controller").size() > 0 else null

func _process(delta):
	# Check if player is near and has enough drives
	if not unlocked and game_controller != null:
		var player_nodes = get_tree().get_nodes_in_group("player")
		if player_nodes.size() > 0:
			var player = player_nodes[0] as Node3D
			if player != null:
				var distance = position.distance_to(player.position)
				if distance < 3.0:
					# Check if player has enough drives
					if game_controller.collected_drives >= required_drives:
						unlock_door()

func unlock_door():
	# Unlock the door
	unlocked = true
	
	# Show victory screen or next level
	if game_controller != null:
		game_controller.victory()