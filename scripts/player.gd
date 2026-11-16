extends "res://scripts/entity_base_2d.gd"

# Player-specific behavior
var sanity: float = 100.0
var max_sanity: float = 100.0
var is_stunned: bool = false
var is_dizzy: bool = false

func _ready():
	super._ready()
	
	# Player specific setup
	health = 100
	max_health = 100
	sanity = 100
	max_sanity = 100
	speed = 3.0
	is_stunned = false
	is_dizzy = false
	
	# Set up collision shape for player
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = RectangleShape2D.new()
	collision_shape.shape.size = Vector2(0.5, 0.5)
	add_child(collision_shape)
	
	# Set up sprite for player
	var sprite = Sprite2D.new()
	sprite.texture = preload("res://assets/textures/entity_texture.png")
	sprite.centered = false
	add_child(sprite)
	
	# Connect to input
	connect("input", self, "handle_input")

func handle_input(delta):
	# Handle player movement
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	
	# Normalize direction to prevent faster diagonal movement
	if direction.length() > 0:
		direction = direction.normalized()
	
	# Apply movement
	velocity = direction * speed
	
	# Apply velocity
	position += velocity * delta
	
	# Reset velocity
	velocity = Vector2.ZERO

func take_damage(damage):
	health -= damage
	if health <= 0:
		queue_free()
		emit_signal("player_died")

func apply_flicker_effect(duration):
	# Apply flicker effect to player
	emit_signal("flicker_effect", duration)

func apply_mental_effect(duration):
	# Apply mental effect to player
	emit_signal("mental_effect", duration)

func stun(duration):
	# Stun player temporarily
	is_stunned = true
	yield(get_tree().create_timer(duration), "timeout")
	is_stunned = false

func dizzy(duration):
	# Make player dizzy temporarily
	is_dizzy = true
	yield(get_tree().create_timer(duration), "timeout")
	is_dizzy = false

func collect_data_drive():
	# Collect a data drive
	emit_signal("data_drive_collected")

func unlock_door():
	# Unlock the exit door
	emit_signal("door_unlocked")

func open_door():
	# Open the exit door
	emit_signal("door_opened")

func close_door():
	# Close the exit door
	emit_signal("door_closed")