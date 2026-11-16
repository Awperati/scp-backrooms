extends Node2D

# Base Entity Class for SCP Backrooms - 2D version
# All entity types inherit from this class

# Entity properties
var entity_name: String = "Base Entity"
var entity_type: String = "base"
var health: float = 100.0
var max_health: float = 100.0
var speed: float = 50.0
var detection_range: float = 100.0
var attack_range: float = 50.0
var attack_damage: float = 25.0
var attack_cooldown: float = 1.0
var last_attack_time: float = 0.0
var is_alive: bool = true
var is_detected: bool = false
var is_attacking: bool = false

# Game references
var game_manager: Node2D = null
var entity_manager: Node2D = null
var entity_interaction_system: Node2D = null

# Animation and visual settings
@export var animation_speed: float = 1.0
@export var sprite_scale: Vector2 = Vector2(1.0, 1.0)
@export var idle_animation: String = "idle"
@export var walk_animation: String = "walk"
@export var attack_animation: String = "attack"
@export var damage_animation: String = "damage"

# Signals
signal entity_spawned(entity)
signal entity_destroyed(entity)
signal entity_damaged(entity, amount)
signal entity_attacked(entity, target, damage)
signal entity_detected(entity, detected)
signal entity_undetected(entity)

func _ready():
	# Initialize entity
	add_to_group("entities")
	add_to_group(entity_type + "_entity")
	
	# Setup entity
	setup_entity()

func setup_entity():
	# Set initial properties
	health = max_health
	
	# Emit signal
	emit_signal("entity_spawned", self)

func set_game_manager(new_game_manager: Node2D):
	game_manager = new_game_manager

func set_entity_manager(new_entity_manager: Node2D):
	entity_manager = new_entity_manager

func set_entity_interaction_system(new_interaction_system: Node2D):
	entity_interaction_system = new_interaction_system

func _process(delta):
	# Update entity behavior
	update_entity(delta)

func update_entity(delta: float):
	# Override in child classes for specific behavior
	pass

func move_towards(target_position: Vector2, delta: float):
	# Move towards target position
	if not is_alive:
		return
	
	var direction = (target_position - position).normalized()
	
	# Move
	position += direction * speed * delta

func take_damage(amount: float):
	# Take damage
	if not is_alive:
		return
	
	health -= amount
	
	# Emit signal
	emit_signal("entity_damaged", self, amount)
	
	# Check if entity is dead
	if health <= 0:
		health = 0
		is_alive = false
		
		# Emit destroy signal
		emit_signal("entity_destroyed", self)

func set_detected(detected: bool):
	# Set detection state
	if is_detected == detected:
		return
	
	is_detected = detected
	
	# Emit signal
	if is_detected:
		emit_signal("entity_detected", self, detected)
	else:
		emit_signal("entity_undetected", self)

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

func is_detected() -> bool:
	return is_detected

func get_entity_type() -> String:
	return entity_type

func set_entity_type(type: String):
	entity_type = type

func get_entity_name() -> String:
	return entity_name

func set_entity_name(name: String):
	entity_name = name

func get_speed() -> float:
	return speed

func set_speed(speed: float):
	speed = speed

func get_detection_range() -> float:
	return detection_range

func set_detection_range(range: float):
	detection_range = range

func get_attack_range() -> float:
	return attack_range

func set_attack_range(range: float):
	attack_range = range

func get_attack_damage() -> float:
	return attack_damage

func set_attack_damage(damage: float):
	attack_damage = damage

func get_attack_cooldown() -> float:
	return attack_cooldown

func set_attack_cooldown(cooldown: float):
	attack_cooldown = cooldown

func get_last_attack_time() -> float:
	return last_attack_time

func set_last_attack_time(time: float):
	last_attack_time = time

func get_is_attacking() -> bool:
	return is_attacking

func set_is_attacking(attacking: bool):
	is_attacking = attacking

func get_game_manager() -> Node2D:
	return game_manager

func get_entity_manager() -> Node2D:
	return entity_manager

func get_entity_interaction_system() -> Node2D:
	return entity_interaction_system

func set_game_manager_ref(game_manager_ref: Node2D):
	game_manager = game_manager_ref

func set_entity_manager_ref(entity_manager_ref: Node2D):
	entity_manager = entity_manager_ref

func set_entity_interaction_system_ref(interaction_system_ref: Node2D):
	entity_interaction_system = interaction_system_ref

func get_entity_properties() -> Dictionary:
	# Get entity properties
	return {
		"name": entity_name,
		"type": entity_type,
		"health": health,
		"max_health": max_health,
		"speed": speed,
		"detection_range": detection_range,
		"attack_range": attack_range,
		"attack_damage": attack_damage,
		"attack_cooldown": attack_cooldown
	}

func set_entity_properties(properties: Dictionary):
	# Set entity properties
	for key in properties.keys():
		match key:
			"name":
				entity_name = properties[key]
			"type":
				entity_type = properties[key]
			"health":
				health = properties[key]
			"max_health":
				max_health = properties[key]
			"speed":
				speed = properties[key]
			"detection_range":
				detection_range = properties[key]
			"attack_range":
				attack_range = properties[key]
			"attack_damage":
				attack_damage = properties[key]
			"attack_cooldown":
				attack_cooldown = properties[key]

func get_entity_settings() -> Dictionary:
	# Get entity settings
	return {
		"animation_speed": animation_speed,
		"sprite_scale": sprite_scale,
		"idle_animation": idle_animation,
		"walk_animation": walk_animation,
		"attack_animation": attack_animation,
		"damage_animation": damage_animation
	}

func set_entity_settings(settings: Dictionary):
	# Set entity settings
	for key in settings.keys():
		match key:
			"animation_speed":
				animation_speed = settings[key]
			"sprite_scale":
				sprite_scale = settings[key]
			"idle_animation":
				idle_animation = settings[key]
			"walk_animation":
				walk_animation = settings[key]
			"attack_animation":
				attack_animation = settings[key]
			"damage_animation":
				damage_animation = settings[key]

func get_entity_stats() -> Dictionary:
	# Get entity statistics
	return {
		"health": health,
		"max_health": max_health,
		"is_alive": is_alive,
		"is_detected": is_detected,
		"is_attacking": is_attacking
	}

func set_entity_stats(stats: Dictionary):
	# Set entity statistics
	for key in stats.keys():
		match key:
			"health":
				health = stats[key]
			"max_health":
				max_health = stats[key]
			"is_alive":
				is_alive = stats[key]
			"is_detected":
				is_detected = stats[key]
			"is_attacking":
				is_attacking = stats[key]