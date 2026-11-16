## Exit door trigger. Checks if player has enough data drives.
extends Area3D

@export var required_drives: int = 1

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		var level_mgr = get_node("/root/Game/Level")
		if level_mgr:
			level_mgr._on_exit_door_triggered(required_drives)
