extends "res://scripts/entity_base_2d.gd"

# Stalker-specific behavior
var ai_state: String = "hiding"
var aggression: float = 0.5
var attacking: bool = false

func _ready():
	super._ready()
	
	# Stalker specific setup
	ai_state = "hiding"
	aggression = 0.5
	speed = 1.0
	health = 25
	attacking = false
	
	# Set up collision shape for stalker
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = RectangleShape2D.new()
	collision_shape.shape.size = Vector2(1, 1)
	add_child(collision_shape)
	
	# Set up sprite for stalker
	var sprite = Sprite2D.new()
	sprite.texture = preload("res://assets/textures/entity_texture.png")
	sprite.centered = false
	add_child(sprite)
	
	# Start hiding
	hide()

func hide():
	# Stalker hides and waits for player to get close
	while true:
		# Wait in hiding spot
		yield(get_tree().create_timer(2.0), "timeout")
		
		# Check if player is close
		if player and position.distance_to(player.position) < 8:
			ai_state = "attacking"
			attacking = true
			# Start attacking
			attack()
		elif player:
			# Move closer to player
			ai_state = "chasing"
			chase_player()

func chase_player():
	# Stalker chases player with stealth
	while ai_state == "chasing":
		if player:
			var direction = (player.position - position).normalized()
			
			# Move stealthily
			velocity = direction * speed * 0.7
			
			# Check if close to player
			if position.distance_to(player.position) < 2:
				ai_state = "attacking"
				attacking = true
				attack()
			
			yield(get_tree().create_timer(0.1), "timeout")
		else:
			yield(get_tree().create_timer(0.1), "timeout")

func attack():
	# Stalker attacks with stealth
	while attacking:
		if player:
			var direction = (player.position - position).normalized()
			velocity = direction * speed * 1.2
			
			# Check if close to player
			if position.distance_to(player.position) < 1.5:
				# Attack player
				player.take_damage(8)
				velocity = Vector2.ZERO
				
				# Make player dizzy
				player.dizzy(2.0)
			
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