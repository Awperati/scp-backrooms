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
				child.door_activated.connect(_on_door_activated)
				child.player_entered_door.connect(_on_player_entered_door)
			elif child.is_in_group("entity_spawner"):
				entity_spawner = child

func _on_drive_collected(drive: Node2D):
	drives_collected += 1
	data_drive_collected.emit(drive)
	if game_manager != null:
		game_manager.on_data_drive_collected()
	if drives_collected >= required_drives and exit_door != null:
		exit_door.activate()

func _on_door_activated(door: Node2D):
	exit_door_activated.emit(door)
	if game_manager != null:
		game_manager.on_exit_door_activated()

func _on_player_entered_door(player: Node2D):
	if is_complete:
		return
	is_complete = true
	if game_manager != null:
		game_manager.on_player_entered_door(player)

func set_game_manager(mgr: Node2D):
	game_manager = mgr

func get_level_name() -> String:
	return level_name

func get_drives_collected() -> int:
	return drives_collected

func get_required_drives() -> int:
	return required_drives

func is_level_complete() -> bool:
	return is_complete

func reset():
	drives_collected = 0
	is_complete = false
	for drive in data_drives:
		if drive != null and is_instance_valid(drive):
			drive.is_collected = false
			if drive.has_node("Sprite"):
				drive.get_node("Sprite").show()
	if exit_door != null:
		exit_door.is_active = false
