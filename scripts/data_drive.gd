## Collectible data drive. Adds to inventory when picked up.
extends Area3D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		GameController.add_item("Data Drive")
		# Play pickup sound
		var audio = get_node("PickupSound") as AudioStreamPlayer3D
		if audio:
			audio.play()
		# Remove self from scene
		queue_free()
