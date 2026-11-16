extends "res://scripts/entity_base.gd"

# Whisperer Entity
# Simple 3D implementation

func _ready():
	super._ready()
	entity_type = "WHISPERER"
	max_health = 70.0
	health = max_health
	speed = 1.2

func _process(delta):
	super._process(delta)
	
	if player != null and is_alive:
		var distance_to_player = get_distance_to_player()
		if distance_to_player < 7.0:
			# Basic movement towards player
			var direction = (player.position - position).normalized()
			velocity = direction * speed
			move_and_slide()