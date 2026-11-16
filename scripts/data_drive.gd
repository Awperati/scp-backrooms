extends "res://scripts/entity.gd"

func _ready():
	super._ready()
	
	# Data drive specific setup
	health = 100
	is_collected = false
	
	# Set up collision shape for data drive
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = RectangleShape2D.new()
	collision_shape.shape.size = Vector2(0.5, 0.5)
	add_child(collision_shape)
	
	# Set up sprite for data drive
	var sprite = Sprite2D.new()
	sprite.texture = preload("res://assets/textures/entity_texture.png")
	sprite.centered = false
	add_child(sprite)
	
	# Connect to player collision
	connect("body_entered", self, "on_player_entered")
	connect("body_exited", self, "on_player_exited")

func on_player_entered(body):
	# Check if player collected the drive
	if body.is_in_group("player"):
		# Collect data drive
		if not is_collected:
			is_collected = true
			emit_signal("data_drive_collected", self)
			# Remove the object
			queue_free()

func on_player_exited(body):
	# No action needed
	pass

func take_damage(damage):
	# Data drives don't take damage
	pass

func collect():
	# Collect the data drive
	if not is_collected:
		is_collected = true
		emit_signal("data_drive_collected", self)
		queue_free()