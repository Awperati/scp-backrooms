extends CharacterBody2D

# Player Character for SCP Backrooms - 2D version
# Handles player movement, health, and interactions

# Player properties
var health: float = 100.0
var max_health: float = 100.0
var speed: float = 100.0
var is_alive: bool = true
var is_invulnerable: bool = false
var invulnerability_timer: float = 0.0

# Game references
var game_manager: Node2D = null
var entity_interaction_system: Node2D = null

# Input settings
@export var move_speed: float = 100.0
@export var jump_force: float = 200.0
@export var gravity: float = 500.0

# Signals
signal player_spawned(player)
signal player_destroyed(player)
signal player_damaged(player, amount)
signal player_healed(player, amount)
signal player_jumped(player)
signal player_moved(player, position)

func _ready():
	# Initialize player
	add_to_group("player")
	
	# Setup player
	setup_player()

func setup_player():
	# Set initial properties
	health = max_health
	
	# Emit signal
	emit_signal("player_spawned", self)

func set_game_manager(new_game_manager: Node2D):
	game_manager = new_game_manager

func set_entity_interaction_system(new_interaction_system: Node2D):
	entity_interaction_system = new_interaction_system

func _process(delta):
	# Update player behavior
	update_player(delta)

func update_player(delta: float):
	# Handle movement
	handle_movement(delta)
	
	# Handle invulnerability
	if is_invulnerable:
		invulnerability_timer -= delta
		if invulnerability_timer <= 0:
			is_invulnerable = false

func handle_movement(delta: float):
	# Handle player movement
	var direction = Vector2.ZERO
	
	# Get input
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	
	# Normalize direction
	if direction.length() > 0:
		direction = direction.normalized()
	
	# Apply movement
	velocity = direction * move_speed
	
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Move player
	move_and_slide()
	
	# Emit movement signal
	emit_signal("player_moved", self, position)

func jump():
	# Handle player jump
	if is_on_floor():
		velocity.y = -jump_force
		
		# Emit jump signal
		emit_signal("player_jumped", self)

func take_damage(amount: float):
	# Take damage
	if is_invulnerable or not is_alive:
		return
	
	health -= amount
	
	# Emit signal
	emit_signal("player_damaged", self, amount)
	
	# Set invulnerability
	is_invulnerable = true
	invulnerability_timer = 1.0
	
	# Check if player is dead
	if health <= 0:
		health = 0
		is_alive = false
		
		# Emit destroy signal
		emit_signal("player_destroyed", self)

func heal(amount: float):
	# Heal player
	if not is_alive:
		return
	
	health = min(health + amount, max_health)
	
	# Emit signal
	emit_signal("player_healed", self, amount)

func get_health() -> float:
	return health

func get_max_health() -> float:
	return max_health

func set_health(health: float):
	health = health

func set_max_health(max_health: float):
	max_health = max_health

func is_alive() -> bool:
	return is_alive

func is_invulnerable() -> bool:
	return is_invulnerable

func get_game_manager() -> Node2D:
	return game_manager

func get_entity_interaction_system() -> Node2D:
	return entity_interaction_system

func set_game_manager_ref(game_manager_ref: Node2D):
	game_manager = game_manager_ref

func set_entity_interaction_system_ref(interaction_system_ref: Node2D):
	entity_interaction_system = interaction_system_ref

func get_player_properties() -> Dictionary:
	# Get player properties
	return {
		"health": health,
		"max_health": max_health,
		"speed": speed,
		"is_alive": is_alive,
		"is_invulnerable": is_invulnerable
	}

func set_player_properties(properties: Dictionary):
	# Set player properties
	for key in properties.keys():
		match key:
			"health":
				health = properties[key]
			"max_health":
				max_health = properties[key]
			"speed":
				speed = properties[key]
			"is_alive":
				is_alive = properties[key]
			"is_invulnerable":
				is_invulnerable = properties[key]

func get_player_settings() -> Dictionary:
	# Get player settings
	return {
		"move_speed": move_speed,
		"jump_force": jump_force,
		"gravity": gravity
	}

func set_player_settings(settings: Dictionary):
	# Set player settings
	for key in settings.keys():
		match key:
			"move_speed":
				move_speed = settings[key]
			"jump_force":
				jump_force = settings[key]
			"gravity":
				gravity = settings[key]

func get_player_stats() -> Dictionary:
	# Get player statistics
	return {
		"health": health,
		"max_health": max_health,
		"is_alive": is_alive,
		"is_invulnerable": is_invulnerable
	}

func set_player_stats(stats: Dictionary):
	# Set player statistics
	for key in stats.keys():
		match key:
			"health":
				health = stats[key]
			"max_health":
				max_health = stats[key]
			"is_alive":
				is_alive = stats[key]
			"is_invulnerable":
				is_invulnerable = stats[key]

func handle_input():
	# Handle player input
	if Input.is_action_just_pressed("jump"):
		jump()