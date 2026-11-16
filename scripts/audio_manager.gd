extends Node

# Audio manager for SCP Backrooms
# Handles background music, sound effects, and audio settings

@onready var background_music = $BackgroundMusic
@onready var sound_effects = $SoundEffects

func _ready():
	# Initialize audio manager
	if background_music:
		background_music.stream = load("res://audio/background_music.wav")
		background_music.volume_db = -10
		background_music.play()

func play_sound(sound_path):
	# Play a sound effect
	if sound_effects:
		var sound_player = AudioStreamPlayer.new()
		sound_player.stream = load(sound_path)
		sound_player.volume_db = -5
		add_child(sound_player)
		sound_player.play()
		# Clean up after playback
		sound_player.connect("finished", Callable(sound_player, "queue_free"))

func play_background_music(music_path):
	# Play background music
	if background_music:
		background_music.stream = load(music_path)
		background_music.play()

func set_master_volume(volume):
	# Set master volume
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume)

func set_sfx_volume(volume):
	# Set sound effects volume
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), volume)

func set_music_volume(volume):
	# Set music volume
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), volume)