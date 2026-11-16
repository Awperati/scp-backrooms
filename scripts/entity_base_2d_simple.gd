extends Node2D

# Entity base properties
@export var entity_type: String = "ANOMALOUS"
@export var health: float = 100.0
@export var max_health: float = 100.0
@export var speed: float = 1.0
@export var detection_range: float = 5.0
@export var attack_range: float = 1.0
@export var damage: float = 10.0
@export var is_active: bool = true

# Entity references
var player: Node2D
var sprite: Sprite2D
var collision_shape: CollisionShape2D

# Movement
var velocity: Vector2 = Vector2.ZERO

func _ready():
	# Set up references
	player = get_tree().get_nodes_in_group("player")[0] if !get_tree().get_nodes_in_group("player").is_empty() else null
	sprite = $Sprite2D
	collision_shape = $CollisionShape2D
	
	# Set initial health
	health = max_health

func _process(delta):
	if not is_active:
		return
	
	# Update entity behavior
	if player:
		var distance_to_player = position.distance_to(player.position)
		if distance_to_player < detection_range:
			# Move toward player
			var direction = (player.position - position).normalized()
			velocity = direction * speed
			
			# Apply movement
			position += velocity * delta
			
			# Check if close enough to attack
			if distance_to_player < attack_range:
				attack_player()
		else:
			# Stop moving if not in detection range
			velocity = Vector2.ZERO
	
	# Apply movement
	position += velocity * delta

func attack_player():
	if player and player.has_method("take_damage"):
		player.take_damage(damage)

func take_damage(amount: float):
	health -= amount
	if health <= 0:
		health = 0
		destroy_entity()

func destroy_entity():
	# Remove entity from game
	is_active = false
	queue_free()