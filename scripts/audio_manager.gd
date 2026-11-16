## Manages all audio in the game
extends Node

# Audio buses
@export var master_bus: String = "Master"
@export var sfx_bus: String = "SFX"
@export var music_bus: String = "Music"

# Audio files
@export var ambient_sound: AudioStream
@export var player_footsteps: AudioStream
@export var entity_sounds: Dictionary = {
	"smiler": preload("res://sounds/entity_smiler.wav"),
	"hound": preload("res://sounds/entity_hound.wav"),
	"stalker": preload("res://sounds/entity_stalker.wav"),
	"watcher": preload("res://sounds/entity_watcher.wav"),
	"whisperer": preload("res://sounds/entity_whisperer.wav")
}

# Audio players
var ambient_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer
var music_player: AudioStreamPlayer

# Game references
var game_controller: Node

func _ready() -> void:
	# Get references to game controller
	game_controller = get_tree().get_first_node_in_group("game_controller")
	
	# Setup audio players
	setup_audio_players()
	
	# Setup signals
	if game_controller:
		game_controller.connect("game_started", self, "_on_game_started")
		game_controller.connect("game_over", self, "_on_game_over")
		game_controller.connect("victory", self, "_on_victory")

func setup_audio_players() -> void:
	# Create audio players
	ambient_player = AudioStreamPlayer.new()
	ambient_player.bus = sfx_bus
	add_child(ambient_player)
	
	sfx_player = AudioStreamPlayer.new()
	sfx_player.bus = sfx_bus
	add_child(sfx_player)
	
	music_player = AudioStreamPlayer.new()
	music_player.bus = music_bus
	add_child(music_player)

func _on_game_started() -> void:
	# Start ambient sound when game starts
	if ambient_sound:
		ambient_player.stream = ambient_sound
		ambient_player.play()

func _on_game_over() -> void:
	# Stop all sounds when game is over
	ambient_player.stop()
	sfx_player.stop()
	music_player.stop()

func _on_victory() -> void:
	# Stop all sounds when player wins
	ambient_player.stop()
	sfx_player.stop()
	music_player.stop()

func play_sound(sound: AudioStream, volume: float = 1.0) -> void:
	# Play a sound effect
	sfx_player.stream = sound
	sfx_player.volume_db = linear_to_db(volume)
	sfx_player.play()

func play_music(music: AudioStream, volume: float = 1.0) -> void:
	# Play background music
	music_player.stream = music
	music_player.volume_db = linear_to_db(volume)
	music_player.play()

func _on_entity_sound(entity_type: String) -> void:
	# Play sound for an entity
	if entity_sounds.has(entity_type):
		play_sound(entity_sounds[entity_type])

func _on_player_footsteps() -> void:
	# Play footstep sounds
	if player_footsteps:
		play_sound(player_footsteps)

func set_master_volume(volume: float) -> void:
	# Set master volume
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(master_bus), linear_to_db(volume))

func set_sfx_volume(volume: float) -> void:
	# Set SFX volume
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(sfx_bus), linear_to_db(volume))

func set_music_volume(volume: float) -> void:
	# Set music volume
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(music_bus), linear_to_db(volume))