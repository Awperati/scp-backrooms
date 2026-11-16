extends "res://scripts/entity_base.gd"

# Watcher Entity
# Simple 3D implementation

func _ready():
	super._ready()
	entity_type = "WATCHER"
	max_health = 120.0
	health = max_health
	speed = 1.0

func _process(delta):
	super._process(delta)
	
	if player != null and is_alive:
		var distance_to_player = get_distance_to_player()
		if distance_to_player < 10.0:
			# Basic movement towards player
			var direction = (player.position - position).normalized()
			velocity = direction * speed
			move_and_slide()