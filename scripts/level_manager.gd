extends Node2D

# Level manager — holds level data and state.
@export var level_name: String = "Level 0"
@export var level_description: String = ""
@export var level_index: int = 0
@export var required_drives: int = 2

var drives_collected: int = 0
var is_complete: bool = false

var data_drives: Array[Node2D] = []
var exit_door: Node2D = null
var entity_spawner: Node2D = null

var game_manager: Node2D = null

signal level_completed(level)
signal data_drive_collected(drive)
signal exit_door_activated(door)

func _ready():
	add_to_group("level")
	_find_level_nodes()

func _find_level_nodes():
	for child in get_children():
		if child is Node2D:
			if child.is_in_group("data_drive"):
				data_drives.append(child)
				child.collected.connect(_on_drive_collected)
			elif child.is_in_group("exit_door"):
				exit_door = child
				exit_door.door_activated.connect(_on_door_activated)
			elif child.is_in_group("entity_spawner"):
				entity_spawner = child

func _on_drive_collected(drive: Node2D):
	drives_collected += 1
	data_drive_collected.emit(drive)
	if drives_collected >= required_drives and exit_door != null:
		exit_door.activate()

func _on_door_activated(_door):
	if not is_complete:
		is_complete = true
		level_completed.emit(self)

func set_game_manager(mgr: Node2D):
	game_manager = mgr

func get_level_name() -> String:
	return level_name

func get_level_index() -> int:
	return level_index

func get_required_drives() -> int:
	return required_drives

func get_drives_collected() -> int:
	return drives_collected

func is_level_complete() -> bool:
	return is_complete

func complete_level():
	if not is_complete:
		is_complete = true
		level_completed.emit(self)
