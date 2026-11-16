extends Node

# Audio management
var background_music: AudioStreamPlayer = null
var sound_effects: Dictionary = {}

func initialize():
	# Setup audio manager
	pass

func play_background_music(stream: AudioStream):
	# Stop any currently playing background music
	if background_music != null and background_music.is_playing():
		background_music.stop()
	
	# Create new background music player
	background_music = AudioStreamPlayer.new()
	background_music.stream = stream
	background_music.volume_db = -10.0
	background_music.play()
	add_child(background_music)

func play_sound_effect(stream: AudioStream, volume_db: float = 0.0):
	# Create sound effect player
	var sound_player = AudioStreamPlayer.new()
	sound_player.stream = stream
	sound_player.volume_db = volume_db
	sound_player.play()
	
	# Add to scene
	add_child(sound_player)
	
	# Remove after playback
	sound_player.connect("finished", Callable(sound_player, "queue_free"))

func stop_background_music():
	if background_music != null:
		background_music.stop()

func set_master_volume(volume_db: float):
	AudioServer.set_bus_volume_db(0, volume_db)