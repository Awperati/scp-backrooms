extends Node

# Main game controller for the SCP Backrooms game

# Game states
enum GameState {
	START_SCREEN,
	PLAYING,
	GAME_OVER,
	VICTORY
}

var current_state = GameState.START_SCREEN
var player_scene = preload("res://scenes/entities/player.tscn")
var current_player = null
var data_drives_collected = 0
var total_data_drives = 5
var level_complete = false

func _ready():
	# Start with the title screen
	show_title_screen()

func show_title_screen():
	# Load and show title screen
	var title_scene = preload("res://scenes/title_screen.tscn")
	var title = title_scene.instantiate()
	add_child(title)
	
	# Connect signals
	title.connect("start_game", self, "start_game")

func start_game():
	# Remove title screen
	for child in get_children():
		if child is Control:
			child.queue_free()
	
	# Start the game
	current_state = GameState.PLAYING
	load_level(0)

func load_level(level_number):
	# Load a specific level
	var level_scene = preload("res://scenes/levels/level_" + str(level_number) + ".tscn")
	var level = level_scene.instantiate()
	add_child(level)
	
	# Spawn player
	spawn_player(level)

func spawn_player(level):
	# Spawn the player at a specific position
	current_player = player_scene.instantiate()
	current_player.position = Vector2(10, 10)
	level.add_child(current_player)
	
	# Connect player signals
	current_player.connect("data_drive_collected", self, "on_data_drive_collected")
	current_player.connect("player_died", self, "on_player_died")
	current_player.connect("door_unlocked", self, "on_door_unlocked")
	current_player.connect("door_opened", self, "on_door_opened")
	current_player.connect("door_closed", self, "on_door_closed")
	current_player.connect("flicker_effect", self, "on_flicker_effect")
	current_player.connect("mental_effect", self, "on_mental_effect")

func on_data_drive_collected(drive):
	# Handle data drive collection
	data_drives_collected += 1
	print("Data drive collected! Total: " + str(data_drives_collected))
	
	# Check if all drives are collected
	if data_drives_collected >= total_data_drives:
		# Unlock the exit door
		unlock_exit_door()

func on_player_died():
	# Handle player death
	current_state = GameState.GAME_OVER
	show_game_over()

func on_door_unlocked():
	# Handle door unlock
	print("Door unlocked!")

func on_door_opened():
	# Handle door opening
	print("Door opened!")

func on_door_closed():
	# Handle door closing
	print("Door closed!")

func on_flicker_effect(duration):
	# Handle flicker effect
	print("Flicker effect applied for " + str(duration) + " seconds")

func on_mental_effect(duration):
	# Handle mental effect
	print("Mental effect applied for " + str(duration) + " seconds")

func unlock_exit_door():
	# Unlock the exit door
	print("Exit door unlocked!")

func show_game_over():
	# Load and show game over screen
	var game_over_scene = preload("res://scenes/game_over.tscn")
	var game_over = game_over_scene.instantiate()
	add_child(game_over)
	
	# Connect signals
	game_over.connect("restart_game", self, "restart_game")

func show_victory():
	# Load and show victory screen
	var victory_scene = preload("res://scenes/victory.tscn")
	var victory = victory_scene.instantiate()
	add_child(victory)
	
	# Connect signals
	victory.connect("restart_game", self, "restart_game")

func restart_game():
	# Restart the game
	for child in get_children():
		if child != self:
			child.queue_free()
	
	# Reset game state
	current_state = GameState.START_SCREEN
	data_drives_collected = 0
	level_complete = false
	
	# Show title screen again
	show_title_screen()

func _process(delta):
	# Update game state
	match current_state:
		GameState.PLAYING:
			# Update player input
			if current_player:
				current_player.handle_input(delta)