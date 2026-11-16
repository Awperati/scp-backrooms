## Whisperer entity. Invisible until sanity < 20, drains sanity nearby.
extends Node3D

var detection_range: float = 8.0
var sanity_drain_rate: float = 2.0
var player: Node3D

func _ready() -> void:
	$WhisperSound.stream = load("res://assets/sounds/entity_whisper.wav")
	$WhisperSound.playing = false
	player = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	if not player:
		return
	
	var dist = global_position.distance_to(player.global_position)
	var sanity = GameController.sanity
	
	if sanity < 20.0 and dist <= detection_range:
		# Visible at low sanity
		visible = true
		$WhisperSound.playing = true
		$WhisperSound.volume_db = -20.0 + (dist / detection_range) * 20.0
		
		# Drain sanity
		GameController.lose_sanity(sanity_drain_rate * delta)
	else:
		visible = false
		$WhisperSound.playing = false
