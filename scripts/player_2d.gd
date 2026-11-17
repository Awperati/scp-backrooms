extends CharacterBody2D

# Player for SCP Backrooms 2D
var health: float = 100.0
var max_health: float = 100.0
var is_alive: bool = true
var is_invulnerable: bool = false
var invulnerability_timer: float = 0.0

var game_manager: Node2D = null
var entity_interaction_system: Node2D = null

@export var move_speed: float = 150.0

signal player_spawned(player)
signal player_destroyed(player)
signal player_damaged(player, amount)
signal player_healed(player, amount)
signal player_moved(player, position)

func _ready():
	add_to_group("player")
	health = max_health
	player_spawned.emit(self)

func _physics_process(delta):
	_handle_movement(delta)
	if is_invulnerable:
		invulnerability_timer -= delta
		if invulnerability_timer <= 0.0:
			is_invulnerable = false

func _handle_movement(delta):
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if direction.length() > 0.0:
		direction = direction.normalized()
	velocity = direction * move_speed
	move_and_slide()
	if direction != Vector2.ZERO:
		player_moved.emit(self, global_position)

func take_damage(amount: float):
	if is_invulnerable or not is_alive:
		return
	health -= amount
	player_damaged.emit(self, amount)
	is_invulnerable = true
	invulnerability_timer = 0.8
	if health <= 0.0:
		health = 0.0
		is_alive = false
		player_destroyed.emit(self)

func heal(amount: float):
	if not is_alive:
		return
	health = min(health + amount, max_health)
	player_healed.emit(self, amount)

func set_game_manager(mgr: Node2D):
	game_manager = mgr

func set_entity_interaction_system(sys: Node2D):
	entity_interaction_system = sys

func get_health() -> float:
	return health

func get_max_health() -> float:
	return max_health

func is_alive_check() -> bool:
	return is_alive
