extends Node

# Main game controller for the SCP Backrooms game.
# Drives the scene flow: title -> game -> game_over / victory.
# This is the GameController AutoLoad singleton.

enum GameState {
	START_SCREEN,
	PLAYING,
	GAME_OVER,
	VICTORY
}

var current_state = GameState.START_SCREEN
var player_scene = preload("res://scenes/entities/player.tscn")
var current_player = null
var current_screen = null
var current_level = null
var data_drives_collected = 0
var total_data_drives = 5
var level_complete = false

# UI-facing state
var inventory: Array[String] = []
var sanity: float = 100.0

signal sanity_changed(value: float)
signal game_over_emitted()

func _ready():
	# Start with the title screen
	show_title_screen()

func _load_screen(path):
	_clear_screen()
	var scene = load(path)
	if scene == null:
		push_warning("Screen scene not found: " + path)
		return null
	var screen = scene.instantiate()
	add_child(screen)
	current_screen = screen
	return screen

func _clear_screen():
	if current_screen != null:
		current_screen.queue_free()
		current_screen = null

func show_title_screen():
	current_state = GameState.START_SCREEN
	var screen = _load_screen("res://scenes/title_screen.tscn")
	if screen:
		screen.connect("start_game", _on_start_game)

func start_game():
	_clear_screen()
	current_state = GameState.PLAYING
	data_drives_collected = 0
	level_complete = false
	load_level(0)

func load_level(level_number):
	# Free the previous level if any
	if current_level != null:
		current_level.queue_free()
		current_level = null

	var path = "res://scenes/levels/level_%d.tscn" % level_number
	var scene = load(path)
	if scene == null:
		push_warning("Level scene not found: " + path)
		return null
	current_level = scene.instantiate()
	add_child(current_level)

	# Spawn the player into the level
	spawn_player()

func spawn_player():
	if current_player != null:
		current_player.queue_free()
		current_player = null

	current_player = player_scene.instantiate()
	current_player.position = Vector2(0, 0)
	add_child(current_player)

	# Connect player signals
	current_player.connect("data_drive_collected", _on_data_drive_collected)
	current_player.connect("player_died", _on_player_died)
	current_player.connect("door_unlocked", _on_door_unlocked)
	current_player.connect("door_opened", _on_door_opened)
	current_player.connect("door_closed", _on_door_closed)
	current_player.connect("flicker_effect", _on_flicker_effect)
	current_player.connect("mental_effect", _on_mental_effect)

func _on_start_game():
	start_game()

func _on_data_drive_collected(_drive = null):
	data_drives_collected += 1
	inventory.append("Data Drive")
	print("Data drive collected! Total: %d/%d" % [data_drives_collected, total_data_drives])

	# All drives collected -> unlock the door and win
	if data_drives_collected >= total_data_drives and not level_complete:
		unlock_exit_door()

func _on_player_died():
	if current_state == GameState.GAME_OVER:
		return
	current_state = GameState.GAME_OVER
	game_over_emitted.emit()
	show_game_over()

func _on_door_unlocked():
	print("Door unlocked!")

func _on_door_opened():
	print("Door opened!")

func _on_door_closed():
	print("Door closed!")

func _on_flicker_effect(duration):
	print("Flicker effect applied for %s seconds" % duration)

func _on_mental_effect(duration):
	print("Mental effect applied for %s seconds" % duration)

func unlock_exit_door():
	level_complete = true
	print("Exit door unlocked! All data drives collected.")
	show_victory()

func show_game_over():
	var screen = _load_screen("res://scenes/game_over.tscn")
	if screen:
		screen.connect("restart_game", _on_restart_game)

func show_victory():
	current_state = GameState.VICTORY
	var screen = _load_screen("res://scenes/victory.tscn")
	if screen:
		screen.connect("restart_game", _on_restart_game)

func _on_restart_game():
	restart_game()

func restart_game():
	# Clear the active screen and the level
	_clear_screen()
	if current_level != null:
		current_level.queue_free()
		current_level = null
	if current_player != null:
		current_player.queue_free()
		current_player = null

	# Reset game state
	current_state = GameState.START_SCREEN
	data_drives_collected = 0
	level_complete = false
	inventory.clear()
	sanity = 100.0

	# Back to the title screen
	show_title_screen()

func _process(delta):
	if current_state == GameState.PLAYING and current_player:
		current_player.handle_input(delta)
		# Decrease sanity over time
		sanity -= 0.5 * delta
		sanity = clamp(sanity, 0.0, 100.0)
		sanity_changed.emit(sanity)
