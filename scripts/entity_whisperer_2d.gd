extends "res://scripts/entity_base_2d.gd"

# Whisperer-specific behavior
var ai_state: String = "whispering"
var aggression: float = 0.4
var attacking: bool = false

func _ready():
	super._ready()
	
	# Whisperer specific setup
	ai_state = "whispering"
	aggression = 0.4
	speed = 1.2
	health = 20
	attacking = false
	
	# Set up collision shape for whisperer
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = RectangleShape2D.new()
	collision_shape.shape.size = Vector2(1, 1)
	add_child(collision_shape)
	
	# Set up sprite for whisperer
	var sprite = Sprite2D.new()
	sprite.texture = preload("res://assets/textures/entity_texture.png")
	sprite.centered = false
	add_child(sprite)
	
	# Start whispering
	whisper()

func whisper():
	# Whisperer whispers to player and waits for reaction
	while true:
		# Wait and whisper
		await get_tree().create_timer(3.0).timeout
		
		# Check if player is close enough to hear
		if player and position.distance_to(player.position) < 7:
			# Start attacking
			ai_state = "attacking"
			attacking = true
			attack()
		elif player:
			# Move closer to player
			ai_state = "chasing"
			chase_player()

func chase_player():
	# Whisperer chases player when close
	while ai_state == "chasing":
		if player:
			var direction = (player.position - position).normalized()
			
			# Move
			velocity = direction * speed * 0.8
			
			# Check if close to player
			if position.distance_to(player.position) < 2:
				ai_state = "attacking"
				attacking = true
				attack()
			
			await get_tree().create_timer(0.1).timeout
		else:
			await get_tree().create_timer(0.1).timeout

func attack():
	# Whisperer attacks with special effect
	while attacking:
		if player:
			var direction = (player.position - position).normalized()
			
			# Move towards player
			velocity = direction * speed
			
			# Check if close to player
			if position.distance_to(player.position) < 1.5:
				# Attack player
				player.take_damage(6)
				velocity = Vector2.ZERO
				
				# Apply mental effect
				player.apply_mental_effect(1.0)
			
			# Move towards player
			velocity = direction * speed
			
			await get_tree().create_timer(0.1).timeout
		else:
			await get_tree().create_timer(0.1).timeout

func take_damage(damage):
	health -= damage
	if health <= 0:
		queue_free()
		emit_signal("entity_destroyed")