extends Node2D

# Player for 2D levels
@export var speed = 100.0

func _ready():
	add_to_group("player")

func _process(delta):
	# Handle player movement
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	
	# Normalize and apply movement
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	translate(velocity * delta)