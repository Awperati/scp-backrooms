extends Node2D

# Base entity class for SCP Backrooms game

# Entity properties
@export var entity_type: String = "ANOMALOUS"
@export var health: float = 100.0
@export var max_health: float = 100.0
@export var speed: float = 1.0
@export var detection_range: float = 5.0
@export var attack_range: float = 1.0
@export var damage: float = 10.0

# Game state
var is_active: bool = true
var player: Node2D = null
var game_controller: Node = null
var velocity: Vector2 = Vector2.ZERO

func _ready():
	# Initialize the entity
	player = get_tree().get_nodes_in_group("player")[0] if get_tree().get_nodes_in_group("player").size() > 0 else null
	game_controller = get_tree().get_nodes_in_group("game_controller")[0] if get_tree().get_nodes_in_group("game_controller").size() > 0 else null
	
	# Add to entity manager
	if game_controller != null:
		game_controller.add_entity(self)

func _process(delta):
	# Override in child classes
	pass

func take_damage(amount: float):
	health -= amount
	if health <= 0:
		health = 0
		# Die and remove from game
		kill_entity()

func kill_entity():
	# Remove entity from game
	if game_controller != null:
		game_controller.remove_entity(self)
	
	# Remove from scene
	queue_free()

func heal(amount: float):
	health = min(health + amount, max_health)

func get_health_percentage():
	return health / max_health

func set_active(active: bool):
	is_active = active

func move_towards(direction: Vector2):
	velocity = direction * speed
	position += velocity * 0.1
	velocity = Vector2.ZERO

func set_player(player_node: Node2D):
	player = player_node