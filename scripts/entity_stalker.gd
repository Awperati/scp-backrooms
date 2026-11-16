extends "res://scripts/entity_base.gd"

# Stalker Entity
# Simple 3D implementation

func _ready():
	super._ready()
	entity_type = "STALKER"
	max_health = 80.0
	health = max_health
	speed = 2.0

func _process(delta):
	super._process(delta)
	
	if player != null and is_alive:
		var distance_to_player = get_distance_to_player()
		if distance_to_player < 8.0:
			# Basic movement towards player
			var direction = (player.position - position).normalized()
			velocity = direction * speed
			move_and_slide()