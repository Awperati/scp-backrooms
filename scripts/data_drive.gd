## Collectible data drive. Adds to inventory and tracks level progress.
extends Area3D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		GameController.add_item("Data Drive")
		# Increment collected drives on level
		var level_mgr = get_node("/root/Game/Level")
		if level_mgr:
			level_mgr.data_drives_collected += 1
		# Play pickup sound
		var audio = get_node("PickupSound") as AudioStreamPlayer3D
		if audio:
			audio.play()
		# Remove self from scene
		queue_free()
