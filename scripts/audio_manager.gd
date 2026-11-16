## Audio manager. Handles ambient sounds, footsteps, entity sounds.
extends Node

var ambient_player: AudioStreamPlayer
var footstep_players: Array[AudioStreamPlayer] = []

func _ready() -> void:
	# Create ambient player
	ambient_player = AudioStreamPlayer.new()
	ambient_player.stream = load("res://assets/sounds/ambient_hum.wav")
	ambient_player.loop = true
	ambient_player.volume_db = -10.0
	add_child(ambient_player)
	ambient_player.play()
	
	# Create footstep players
	for i in range(4):
		var player = AudioStreamPlayer.new()
		player.stream = load("res://assets/sounds/footstep_%d.wav" % (i + 1))
		player.bus = "Footsteps"
		add_child(player)
		footstep_players.append(player)

func play_footstep() -> void:
	var idx = randi() % footstep_players.size()
	var player = footstep_players[idx]
	player.play()

func play_entity_sound(sound_type: String) -> void:
	var path = "res://assets/sounds/entity_%s.wav" % sound_type
	var stream = load(path)
	if stream:
		var player = AudioStreamPlayer.new()
		player.stream = stream
		player.one_shot = true
		add_child(player)
		player.play()

func set_ambient_volume(volume: float) -> void:
	if ambient_player:
		ambient_player.volume_db = volume
