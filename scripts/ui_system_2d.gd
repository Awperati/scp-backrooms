extends Control

# UI System — health bar, level info, menus. Self-contained, no external scenes.

var game_manager: Node2D = null
var player: Node2D = null

@export var show_debug_info: bool = false

signal ui_updated()

var health_bar: ProgressBar = null
var level_label: Label = null
var entity_count_label: Label = null
var status_label: Label = null

func _ready():
	add_to_group("ui_system")
	_build_ui()

func _build_ui():
	# Health bar
	health_bar = ProgressBar.new()
	health_bar.name = "HealthBar"
	health_bar.position = Vector2(10, 10)
	health_bar.size = Vector2(200, 20)
	health_bar.max_value = 100.0
	health_bar.value = 100.0
	add_child(health_bar)

	# Level label
	level_label = Label.new()
	level_label.name = "LevelLabel"
	level_label.position = Vector2(10, 35)
	level_label.text = "Level 0"
	add_child(level_label)

	# Entity count label
	entity_count_label = Label.new()
	entity_count_label.name = "EntityCount"
	entity_count_label.position = Vector2(10, 55)
	entity_count_label.text = "Entities: 0"
	add_child(entity_count_label)

	# Status label
	status_label = Label.new()
	status_label.name = "StatusLabel"
	status_label.position = Vector2(10, 75)
	status_label.text = ""
	add_child(status_label)

func set_game_manager(mgr: Node2D):
	game_manager = mgr

func set_player(p: Node2D):
	player = p
	if player != null:
		player.player_damaged.connect(_on_player_damaged)
		player.player_healed.connect(_on_player_healed)
		player.player_destroyed.connect(_on_player_destroyed)

func _on_player_damaged(_p, amount):
	_update_health()

func _on_player_healed(_p, _amount):
	_update_health()

func _on_player_destroyed(_p):
	status_label.text = "YOU DIED"
	status_label.add_theme_color_override("font_color", Color.RED)

func _update_health():
	if player == null:
		return
	health_bar.value = player.get_health()
	health_bar.max_value = player.get_max_health()

func set_level_info(level_name: String, drives_collected: int, required: int):
	level_label.text = "%s | Drives: %d/%d" % [level_name, drives_collected, required]

func set_entity_count(count: int):
	entity_count_label.text = "Entities: %d" % count

func show_message(msg: String):
	status_label.text = msg
	status_label.add_theme_color_override("font_color", Color.WHITE)
