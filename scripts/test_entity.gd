extends "res://scripts/entity_base.gd"

# Test entity that inherits from entity_base.gd
# This demonstrates how to properly extend the base class

func _ready():
	super._ready()
	print("Test entity initialized with base class properties")
	print("Entity type: %s" % entity_type)
	print("Health: %s" % health)
	print("Max health: %s" % max_health)

func _process(delta):
	super._process(delta)
	# Example behavior
	if player != null and is_player_in_range(detection_range):
		# Move towards player
		var direction = (player.position - position).normalized()
		velocity = direction * speed
		move_and_slide()

func _on_health_changed(new_health: float, max_health: float):
	print("Health changed to: %s/%s" % [new_health, max_health])

func _on_entity_damaged(amount: float, new_health: float):
	print("Took %s damage, health is now %s" % [amount, new_health])

func _on_entity_killed(entity):
	print("Entity killed: %s" % entity_type)