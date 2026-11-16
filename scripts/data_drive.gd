extends Node3D

# Data drive properties
@export var drive_id: String = "drive_001"
@export var collected: bool = false

# Game references
var game_controller: Node = null

func _ready():
	# Setup data drive
	game_controller = get_tree().get_nodes_in_group("game_controller")[0] if get_tree().get_nodes_in_group("game_controller").size() > 0 else null

func _process(delta):
	# Check if player is near
	if not collected:
		var player_nodes = get_tree().get_nodes_in_group("player")
		if player_nodes.size() > 0:
			var player = player_nodes[0] as Node3D
			if player != null:
				var distance = position.distance_to(player.position)
				if distance < 2.0:
					# Collect the drive
					collected = true
					if game_controller != null:
						game_controller.collect_drive()
					
					# Remove the drive from the scene
					queue_free()