extends "res://scripts/entity.gd"

func _ready():
	super._ready()
	
	# Hound specific setup
	ai_state = "patrolling"
	aggression = 0.7
	speed = 2.0
	health = 30
	attacking = false
	
	# Set up collision shape for hound
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = RectangleShape2D.new()
	collision_shape.shape.size = Vector2(1.5, 1.5)
	add_child(collision_shape)
	
	# Set up sprite for hound
	var sprite = Sprite2D.new()
	sprite.texture = preload("res://assets/textures/entity_texture.png")
	sprite.centered = false
	add_child(sprite)
	
	# Start patrolling
	patrol()

func patrol():
	# Hound patrols more aggressively than smiler
	while true:
		# Move in a random pattern
		for i in range(10):
			var direction = Vector2(randf() * 2 - 1, randf() * 2 - 1).normalized()
			move_towards(direction)
			yield(get_tree().create_timer(0.5), "timeout")
			
			# Check if player is nearby
			if player and position.distance_to(player.position) < 10:
				ai_state = "attacking"
				attacking = true
				attack()
				break
		
		# Add a small pause
		yield(get_tree().create_timer(0.5), "timeout")
		
		# Randomly change state
		if randf() > 0.8:
			ai_state = "investigating"
			# Investigate sound
			investigate_sound()
		else:
			ai_state = "patrolling"
			attacking = false

func investigate_sound():
	# Hound investigates sounds in the environment
	while ai_state == "investigating":
		# Move towards sound source
		if sound_source:
			var direction = (sound_source.position - position).normalized()
			velocity = direction * speed * 0.5
			
			# Check if close to sound source
			if position.distance_to(sound_source.position) < 3:
				ai_state = "patrolling"
				attacking = false
				break
			
			yield(get_tree().create_timer(0.1), "timeout")
		else:
			yield(get_tree().create_timer(0.1), "timeout")

func attack():
	# Hound attacks with high aggression
	while attacking:
		if player:
			var direction = (player.position - position).normalized()
			velocity = direction * speed
			
			# Check if close to player
			if position.distance_to(player.position) < 3:
				# Attack player
				player.take_damage(10)
				velocity = Vector2.ZERO
				
				# Stun player briefly
				player.stun(1.0)
			
			# Move towards player
			velocity = direction * speed
			
			yield(get_tree().create_timer(0.1), "timeout")
		else:
			yield(get_tree().create_timer(0.1), "timeout")

func take_damage(damage):
	health -= damage
	if health <= 0:
		queue_free()
		emit_signal("entity_destroyed")