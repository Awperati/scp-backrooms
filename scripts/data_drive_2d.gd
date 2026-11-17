extends Node2D

# Data drive — player collects these to unlock the exit.
@export var drive_id: String = "drive_001"
var is_collected: bool = false

signal collected(drive)

func _ready():
	add_to_group("data_drive")

func collect():
	if is_collected:
		return
	is_collected = true
	if has_node("Sprite"):
		$Sprite.hide()
	collected.emit(self)

func get_drive_id() -> String:
	return drive_id

func is_collected_check() -> bool:
	return is_collected
