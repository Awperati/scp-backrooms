## Sanity system. Tracks sanity, triggers effects at thresholds.
extends Node3D

var current_sanity: float = 100.0
var sanity_thresholds: Dictionary = {
	"low": 30.0,
	"very_low": 15.0,
	"critical": 5.0
}

var hallucination_timer: float = 0.0
var regeneration_rate: float = 1.0

func _ready() -> void:
	GameController.sanity_changed.connect(_on_sanity_changed)

func _process(delta: float) -> void:
	current_sanity = GameController.sanity
	
	# Regeneration in light, no entities nearby
	if current_sanity < 50.0:
		var flashlight = get_node("../Body/PlayerFlashlight")
		var is_lit = flashlight.flashlight_on if flashlight else false
		if is_lit:
			GameController.add_sanity(regeneration_rate * delta)
	
	# Sanity hallucinations
	if current_sanity < 15.0:
		hallucination_timer += delta
		if hallucination_timer > 3.0:
			hallucination_timer = 0.0
			_trigger_hallucination()

func _on_sanity_changed(value: float) -> void:
	current_sanity = value
	if current_sanity < 30.0:
		# Flashlight flicker handled by player_flashlight
		pass
	if current_sanity < 15.0:
		# Audio hallucinations handled by audio_manager
		pass
	if current_sanity < 5.0:
		# Visual distortion handled by shader
		pass

func _trigger_hallucination() -> void:
	var audio = get_node("../Body/FootstepSound")
	if audio and audio.stream:
		audio.play()
