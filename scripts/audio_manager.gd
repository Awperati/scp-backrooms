extends Node

# Audio Manager for SCP Backrooms game
# Handles all sound effects and background music

# Audio buses
const MUSIC_BUS = "Music"
const SFX_BUS = "SoundEffects"
const AMBIENT_BUS = "Ambient"

# Audio streams
var background_music: AudioStream = null
var footstep_sound: AudioStream = null
var jump_sound: AudioStream = null
var land_sound: AudioStream = null
var damage_sound: AudioStream = null
var sanity_loss_sound: AudioStream = null
var entity_sound: AudioStream = null
var pickup_sound: AudioStream = null
var level_up_sound: AudioStream = null

# Audio players
@onready var music_player: AudioStreamPlayer = null
@onready var sfx_player: AudioStreamPlayer = null
@onready var ambient_player: AudioStreamPlayer = null

# Game references
var player: Node = null
var game_controller: Node = null

func _ready():
	# Initialize audio players
	music_player = $MusicPlayer
	sfx_player = $SFXPlayer
	ambient_player = $AmbientPlayer
	
	# Load audio resources
	load_audio_resources()
	
	# Connect to player events
	connect_to_player_events()
	
	# Start with ambient sound
	start_ambient_sound()

func load_audio_resources():
	# Load all audio resources from assets folder
	background_music = preload("res://assets/audio/music/background_music.ogg")
	footstep_sound = preload("res://assets/audio/sounds/footsteps.ogg")
	jump_sound = preload("res://assets/audio/sounds/jump.ogg")
	land_sound = preload("res://assets/audio/sounds/land.ogg")
	damage_sound = preload("res://assets/audio/sounds/damage.ogg")
	sanity_loss_sound = preload("res://assets/audio/sounds/sanity_loss.ogg")
	entity_sound = preload("res://assets/audio/sounds/entity_sound.ogg")
	pickup_sound = preload("res://assets/audio/sounds/pickup.ogg")
	level_up_sound = preload("res://assets/audio/sounds/level_up.ogg")
	
	# Set initial audio streams
	if music_player != null:
		music_player.stream = background_music
		music_player.volume_db = -10.0

func connect_to_player_events():
	# Connect to player events
	pass

func start_background_music():
	if music_player != null:
		music_player.play()

func stop_background_music():
	if music_player != null:
		music_player.stop()

func play_sound(sound: AudioStream, volume_db: float = 0.0, pitch_scale: float = 1.0):
	if sfx_player != null and sound != null:
		sfx_player.stream = sound
		sfx_player.volume_db = volume_db
		sfx_player.pitch_scale = pitch_scale
		sfx_player.play()

func play_ambient_sound():
	if ambient_player != null and ambient_player.stream != null:
		ambient_player.play()

func stop_ambient_sound():
	if ambient_player != null:
		ambient_player.stop()

func start_ambient_sound():
	if ambient_player != null:
		ambient_player.stream = preload("res://assets/audio/ambient/ambient.ogg")
		ambient_player.volume_db = -15.0
		ambient_player.play()

func play_footstep_sound():
	play_sound(footstep_sound, -15.0, randf_range(0.8, 1.2))

func play_jump_sound():
	play_sound(jump_sound, -10.0, randf_range(0.9, 1.1))

func play_land_sound():
	play_sound(land_sound, -10.0, randf_range(0.9, 1.1))

func play_damage_sound():
	play_sound(damage_sound, -5.0, randf_range(0.9, 1.1))

func play_sanity_loss_sound():
	play_sound(sanity_loss_sound, -10.0, randf_range(0.8, 1.2))

func play_entity_sound():
	play_sound(entity_sound, -15.0, randf_range(0.9, 1.1))

func play_pickup_sound():
	play_sound(pickup_sound, -10.0, randf_range(0.9, 1.1))

func play_level_up_sound():
	play_sound(level_up_sound, -5.0, randf_range(0.9, 1.1))

func set_music_volume(volume_db: float):
	if music_player != null:
		music_player.volume_db = volume_db

func set_sfx_volume(volume_db: float):
	if sfx_player != null:
		sfx_player.volume_db = volume_db

func set_ambient_volume(volume_db: float):
	if ambient_player != null:
		ambient_player.volume_db = volume_db