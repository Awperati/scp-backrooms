extends "res://scripts/entity.gd"

func _ready():
	super._ready()
	
	# Watcher specific setup
	ai_state = "watching"
	aggression = 0.2
	speed = 0.8
	health = 15
	attacking = false
	
	# Set up collision shape for watcher
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = RectangleShape2D.new()
	collision_shape.shape.size = Vector2(1, 1)
	add_child(collision_shape)
	
	# Set up sprite for watcher
	var sprite = Sprite2D.new()
	sprite.texture = preload("res://assets/textures/entity_texture.png")
	sprite.centered = false
	add_child(sprite)
	
	# Start watching
	watch()

func watch():
	# Watcher stays still and watches for player
	while true:
		# Wait in place
		yield(get_tree().create_timer(1.0), "timeout")
		
		# Check if player is visible
		if player and is_player_visible():
			# Start attacking
			ai_state = "attacking"
			attacking = true
			attack()
		elif player and position.distance_to(player.position) < 5:
			# Start chasing
			ai_state = "chasing"
			chase_player()

func chase_player():
	# Watcher chases player when close
	while ai_state == "chasing":
		if player:
			var direction = (player.position - position).normalized()
			
			# Move slowly
			velocity = direction * speed * 0.5
			
			# Check if close to player
			if position.distance_to(player.position) < 2:
				ai_state = "attacking"
				attacking = true
				attack()
			
			yield(get_tree().create_timer(0.1), "timeout")
		else:
			yield(get_tree().create_timer(0.1), "timeout")

func attack():
	# Watcher attacks with special effect
	while attacking:
		if player:
			var direction = (player.position - position).normalized()
			
			# Slowly move towards player
			velocity = direction * speed
			
			# Check if close to player
			if position.distance_to(player.position) < 1:
				# Attack player
				player.take_damage(3)
				velocity = Vector2.ZERO
				
				# Apply visual effect
				player.apply_flicker_effect(0.5)
			
			# Move towards player
			velocity = direction * speed
			
			yield(get_tree().create_timer(0.1), "timeout")
		else:
			yield(get_tree().create_timer(0.1), "timeout")

func is_player_visible():
	# Simple visibility check
	if not player:
		return false
	
	# Check distance
	var distance = position.distance_to(player.position)
	if distance > 10:
		return false
	
	# Simple line-of-sight check (would be more complex in full implementation)
	return true

func take_damage(damage):
	health -= damage
	if health <= 0:
		queue_free()
		emit_signal("entity_destroyed")