extends "res://scripts/entity.gd"

func _ready():
	super._ready()
	
	# Exit door specific setup
	health = 200
	is_unlocked = false
	is_open = false
	
	# Set up collision shape for door
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = RectangleShape2D.new()
	collision_shape.shape.size = Vector2(1, 2)
	add_child(collision_shape)
	
	# Set up sprite for door
	var sprite = Sprite2D.new()
	sprite.texture = preload("res://assets/textures/entity_texture.png")
	sprite.centered = false
	add_child(sprite)
	
	# Connect to player collision
	connect("body_entered", self, "on_player_entered")
	connect("body_exited", self, "on_player_exited")

func on_player_entered(body):
	# Check if player is near door
	if body.is_in_group("player"):
		# Check if door is unlocked
		if is_unlocked:
			# Open door
			if not is_open:
				is_open = true
				emit_signal("door_opened", self)
		else:
			# Show message that door is locked
			emit_signal("door_locked", self)

func on_player_exited(body):
	# No action needed
	pass

func take_damage(damage):
	# Doors don't take damage
	pass

func unlock():
	# Unlock the door
	is_unlocked = true

func open():
	# Open the door
	is_open = true
	emit_signal("door_opened", self)

func close():
	# Close the door
	is_open = false
	emit_signal("door_closed", self)