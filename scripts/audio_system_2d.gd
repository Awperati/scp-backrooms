extends Node2D

# Audio System for SCP Backrooms - 2D version
# Handles music, sound effects, and audio management

# Audio settings
@export var master_volume: float = 1.0
@export var music_volume: float = 0.7
@export var sfx_volume: float = 1.0

# Audio players
var music_player: AudioStreamPlayer = null
var sfx_player: AudioStreamPlayer = null

# Game references
var game_manager: Node2D = null

# Sound effects
var sound_effects = {
	"player_hit": preload("res://sounds/player_hit.wav"),
	"player_heal": preload("res://sounds/player_heal.wav"),
	"entity_hit": preload("res://sounds/entity_hit.wav"),
	"entity_death": preload("res://sounds/entity_death.wav"),
	"entity_attack": preload("res://sounds/entity_attack.wav"),
	"level_complete": preload("res://sounds/level_complete.wav"),
	"game_over": preload("res://sounds/game_over.wav"),
	"start_menu": preload("res://sounds/start_menu.wav"),
	"pause": preload("res://sounds/pause.wav")
}

# Music tracks
var music_tracks = {
	"level_1": preload("res://music/level_1.wav"),
	"level_2": preload("res://music/level_2.wav"),
	"level_3": preload("res://music/level_3.wav"),
	"level_4": preload("res://music/level_4.wav"),
	"level_5": preload("res://music/level_5.wav"),
	"game_over": preload("res://music/game_over.wav"),
	"start_menu": preload("res://music/start_menu.wav")
}

# Currently playing music
var current_music: String = ""

# Signals
signal music_started(music_name)
signal music_stopped(music_name)
signal sfx_played(sfx_name)

func _ready():
	# Initialize audio system
	add_to_group("audio_system")
	
	# Connect to game manager
	connect_to_game_manager()
	
	# Setup audio players
	setup_audio_players()

func setup_audio_players():
	# Create audio players if they don't exist
	if music_player == null:
		music_player = AudioStreamPlayer.new()
		music_player.name = "MusicPlayer"
		add_child(music_player)
	
	if sfx_player == null:
		sfx_player = AudioStreamPlayer.new()
		sfx_player.name = "SFXPlayer"
		add_child(sfx_player)
	
	# Set volumes
	music_player.volume_db = db_to_linear(music_volume)
	sfx_player.volume_db = db_to_linear(sfx_volume)

func set_game_manager(new_game_manager: Node2D):
	game_manager = new_game_manager
	
	# Connect to game manager
	connect_to_game_manager()

func connect_to_game_manager():
	if game_manager != null:
		game_manager.connect("game_started", self, "on_game_started")
		game_manager.connect("game_paused", self, "on_game_paused")
		game_manager.connect("game_resumed", self, "on_game_resumed")
		game_manager.connect("game_over", self, "on_game_over")
		game_manager.connect("level_loaded", self, "on_level_loaded")
		game_manager.connect("level_completed", self, "on_level_completed")

func on_game_started():
	# Called when game starts
	play_music("start_menu")

func on_game_paused():
	# Called when game pauses
	# Pause music if playing
	if music_player != null and music_player.is_playing():
		music_player.pause()

func on_game_resumed():
	# Called when game resumes
	# Resume music if paused
	if music_player != null and not music_player.is_playing():
		music_player.play()

func on_game_over():
	# Called when game ends
	play_music("game_over")

func on_level_loaded(level: int):
	# Called when level loads
	# Play appropriate music
	var music_name = "level_" + str(level)
	if music_tracks.has(music_name):
		play_music(music_name)

func on_level_completed(level: int):
	# Called when level completes
	play_music("level_complete")

func set_music_player(new_music_player: AudioStreamPlayer):
	music_player = new_music_player

func set_sfx_player(new_sfx_player: AudioStreamPlayer):
	sfx_player = new_sfx_player

func set_master_volume(volume: float):
	master_volume = volume
	update_volumes()

func set_music_volume(volume: float):
	music_volume = volume
	update_volumes()

func set_sfx_volume(volume: float):
	sfx_volume = volume
	update_volumes()

func update_volumes():
	# Update all audio volumes
	if music_player != null:
		music_player.volume_db = db_to_linear(music_volume)
	
	if sfx_player != null:
		sfx_player.volume_db = db_to_linear(sfx_volume)

func db_to_linear(db: float) -> float:
	# Convert decibels to linear scale
	return pow(10.0, db / 20.0)

func play_music(music_name: String):
	# Play music track
	if not music_tracks.has(music_name):
		print("Music track not found: " + music_name)
		return
	
	if music_player != null:
		# Stop current music
		if music_player.is_playing():
			music_player.stop()
		
		# Set new music
		music_player.stream = music_tracks[music_name]
		
		# Play
		music_player.play()
		
		# Update current music
		current_music = music_name
		
		# Emit signal
		emit_signal("music_started", music_name)

func stop_music():
	# Stop current music
	if music_player != null and music_player.is_playing():
		music_player.stop()
		current_music = ""
		
		# Emit signal
		emit_signal("music_stopped", current_music)

func play_sound(sound_name: String):
	# Play sound effect
	if not sound_effects.has(sound_name):
		print("Sound effect not found: " + sound_name)
		return
	
	if sfx_player != null:
		# Set sound
		sfx_player.stream = sound_effects[sound_name]
		
		# Play
		sfx_player.play()
		
		# Emit signal
		emit_signal("sfx_played", sound_name)

func play_sound_by_name(sound_name: String):
	# Play sound effect by name
	play_sound(sound_name)

func get_current_music() -> String:
	return current_music

func is_music_playing() -> bool:
	if music_player != null:
		return music_player.is_playing()
	return false

func get_sound_effects() -> Dictionary:
	return sound_effects

func get_music_tracks() -> Dictionary:
	return music_tracks

func set_sound_effects(sounds: Dictionary):
	# Set sound effects
	for key in sounds.keys():
		sound_effects[key] = sounds[key]

func set_music_tracks(tracks: Dictionary):
	# Set music tracks
	for key in tracks.keys():
		music_tracks[key] = tracks[key]