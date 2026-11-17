extends Area2D

# Exit door — activates when enough data drives collected.
@export var door_id: String = "exit_door_001"
@export var required_drives: int = 2
var is_active: bool = false

signal door_activated(door)
signal player_entered_door(player)

func _ready():
	add_to_group("exit_door")
	body_entered.connect(_on_body_entered)

func activate():
	if is_active:
		return
	is_active = true
	if has_node("Sprite"):
		$Sprite.modulate = Color(0.2, 1.0, 0.2, 1.0)
	door_activated.emit(self)

func _on_body_entered(body: Node2D):
	if body.is_in_group("player") and is_active:
		player_entered_door.emit(body)

func set_active(active: bool):
	is_active = active
	if has_node("Sprite"):
		$Sprite.modulate = Color(1, 1, 1, 1) if active else Color(1, 1, 1, 0.3)

func get_door_id() -> String:
	return door_id

func is_active_check() -> bool:
	return is_active
