extends Node

# Audio System — music, SFX, ambient audio. No external file dependencies.

@export var master_volume: float = 1.0
@export var music_volume: float = 0.7
@export var sfx_volume: float = 1.0

var game_manager: Node2D = null
var current_music: String = ""

# Audio players (created at runtime)
var music_player: AudioStreamPlayer = null
var sfx_player: AudioStreamPlayer = null

signal music_started(name)
signal music_stopped(name)
signal sfx_played(name)

func _ready():
	add_to_group("audio_system")
	music_player = AudioStreamPlayer.new()
	music_player.name = "MusicPlayer"
	music_player.volume_db = linear_to_db(music_volume)
	add_child(music_player)
	sfx_player = AudioStreamPlayer.new()
	sfx_player.name = "SFXPlayer"
	sfx_player.volume_db = linear_to_db(sfx_volume)
	add_child(sfx_player)

func set_game_manager(mgr: Node2D):
	game_manager = mgr

func play_music(track_name: String):
	if music_player == null:
		return
	if current_music == track_name and music_player.playing:
		return
	current_music = track_name
	# No actual audio files yet — just track state
	music_started.emit(track_name)

func stop_music():
	if music_player != null and music_player.playing:
		music_player.stop()
		music_stopped.emit(current_music)
	current_music = ""

func play_sfx(sfx_name: String):
	# No actual audio files yet — just emit signal
	sfx_played.emit(sfx_name)

func set_master_volume(v: float):
	master_volume = v
	if music_player:
		music_player.volume_db = linear_to_db(v * music_volume)
	if sfx_player:
		sfx_player.volume_db = linear_to_db(v * sfx_volume)

func set_music_volume(v: float):
	music_volume = v
	if music_player:
		music_player.volume_db = linear_to_db(v * master_volume)

func set_sfx_volume(v: float):
	sfx_volume = v
	if sfx_player:
		sfx_player.volume_db = linear_to_db(v * master_volume)

func pause_audio():
	if music_player:
		music_player.stream_paused = true
	if sfx_player:
		sfx_player.stream_paused = true

func resume_audio():
	if music_player:
		music_player.stream_paused = false
	if sfx_player:
		sfx_player.stream_paused = false
