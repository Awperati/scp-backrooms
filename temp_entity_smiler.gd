extends "res://scripts/entity_base.gd"

# Smiler Entity
# Simple 3D implementation

func _ready():
	super._ready()
	entity_type = "SMILER"
	max_health = 60.0
	health = max_health
	speed = 1.5

func _process(delta):
	super._process(delta)
	
	if player != null and is_alive:
		var distance_to_player = get_distance_to_player()
		if distance_to_player < 6.0:
			# Basic movement towards player
			var direction = (player.position - position).normalized()
			velocity = direction * speed
			move_and_slide()