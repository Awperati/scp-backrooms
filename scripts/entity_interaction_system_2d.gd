extends Node2D

# Entity Interaction System for SCP Backrooms - 2D version
# Handles player-entity interactions, collisions, damage, and game mechanics

# Game references
var game_manager: Node2D = null
var entity_manager: Node2D = null
var player: Node2D = null

# Player settings
var player_health: float = 100.0
var player_max_health: float = 100.0
var player_invulnerable: bool = false
var player_invulnerability_timer: float = 0.0

# Entity interaction settings
@export var damage_multiplier: float = 1.0
@export var detection_range: float = 100.0
@export var attack_range: float = 50.0
@export var attack_cooldown: float = 1.0
@export var player_damage: float = 25.0
@export var entity_damage: float = 25.0

# Signals
signal player_damage_taken(player, amount)
signal player_damage_dealt(player, amount)
signal entity_damage_taken(entity, amount)
signal entity_damage_dealt(entity, target, amount)
signal entity_detected(entity, player)
signal entity_undetected(entity)
signal entity_attacked(entity, target, damage)
signal player_attacked(player, entity, damage)
signal player_died(player)
signal player_healed(player, amount)
signal entity_spawned(entity)
signal entity_destroyed(entity)
signal collision_detected(entity, target, type)

func _ready():
	# Initialize interaction system
	add_to_group("entity_interaction_system")
	
	# Setup interaction system
	setup_interaction_system()

func setup_interaction_system():
	# Initialize player stats
	player_health = player_max_health

func set_game_manager(new_game_manager: Node2D):
	game_manager = new_game_manager

func set_entity_manager(new_entity_manager: Node2D):
	entity_manager = new_entity_manager

func set_player(new_player: Node2D):
	player = new_player

func _process(delta):
	# Update interaction system
	update_interaction_system(delta)

func update_interaction_system(delta: float):
	# Handle player invulnerability
	if player_invulnerable:
		player_invulnerability_timer -= delta
		if player_invulnerability_timer <= 0:
			player_invulnerable = false

func handle_player_entity_collision(player: Node2D, entity: Node2D):
	# Handle collision between player and entity
	if player == null or entity == null:
		return
	
	# Check if player is invulnerable
	if player_invulnerable:
		return
	
	# Check if entity is alive
	if not entity.is_alive():
		return
	
	# Get entity damage
	var damage = entity.get_attack_damage() * damage_multiplier
	
	# Deal damage to player
	take_player_damage(damage)
	
	# Deal damage to entity (if it can attack)
	if entity.has_method("attack"):
		entity.attack(player)

func handle_entity_player_collision(entity: Node2D, player: Node2D):
	# Handle collision between entity and player
	if entity == null or player == null:
		return
	
	# Check if entity is alive
	if not entity.is_alive():
		return
	
	# Check if player is invulnerable
	if player_invulnerable:
		return
	
	# Get player damage
	var damage = player_damage * damage_multiplier
	
	# Deal damage to entity
	take_entity_damage(entity, damage)
	
	# Deal damage to player
	var entity_damage = entity.get_attack_damage() * damage_multiplier
	take_player_damage(entity_damage)
	
	# Emit collision signal
	emit_signal("collision_detected", entity, player, "player_entity")

func take_player_damage(amount: float):
	# Take damage to player
	if player == null or player_invulnerable:
		return
	
	player_health -= amount
	
	# Emit signal
	emit_signal("player_damage_taken", player, amount)
	
	# Check if player is dead
	if player_health <= 0:
		player_health = 0
		emit_signal("player_died", player)

func deal_player_damage(entity: Node2D):
	# Deal damage to entity
	if player == null or entity == null:
		return
	
	# Check if entity is alive
	if not entity.is_alive():
		return
	
	# Get damage
	var damage = player_damage * damage_multiplier
	
	# Deal damage to entity
	take_entity_damage(entity, damage)
	
	# Emit signal
	emit_signal("player_damage_dealt", player, damage)

func take_entity_damage(entity: Node2D, amount: float):
	# Take damage to entity
	if entity == null:
		return
	
	entity.take_damage(amount)
	
	# Emit signal
	emit_signal("entity_damage_taken", entity, amount)

func deal_entity_damage(entity: Node2D, target: Node2D):
	# Deal damage from entity to target
	if entity == null or target == null:
		return
	
	# Get damage
	var damage = entity.get_attack_damage() * damage_multiplier
	
	# Deal damage
	if target.has_method("take_damage"):
		target.take_damage(damage)
	
	# Emit signal
	emit_signal("entity_damage_dealt", entity, target, damage)

func heal_player(amount: float):
	# Heal player
	if player == null:
		return
	
	player_health = min(player_health + amount, player_max_health)
	
	# Emit signal
	emit_signal("player_healed", player, amount)

func set_player_health(health: float):
	player_health = health

func set_player_max_health(max_health: float):
	player_max_health = max_health

func get_player_health() -> float:
	return player_health

func get_player_max_health() -> float:
	return player_max_health

func get_player_invulnerable() -> bool:
	return player_invulnerable

func set_player_invulnerable(invulnerable: bool):
	player_invulnerable = invulnerable

func get_damage_multiplier() -> float:
	return damage_multiplier

func set_damage_multiplier(multiplier: float):
	damage_multiplier = multiplier

func get_detection_range() -> float:
	return detection_range

func set_detection_range(range: float):
	detection_range = range

func get_attack_range() -> float:
	return attack_range

func set_attack_range(range: float):
	attack_range = range

func get_attack_cooldown() -> float:
	return attack_cooldown

func set_attack_cooldown(cooldown: float):
	attack_cooldown = cooldown

func get_player_damage() -> float:
	return player_damage

func set_player_damage(damage: float):
	player_damage = damage

func get_entity_damage() -> float:
	return entity_damage

func set_entity_damage(damage: float):
	entity_damage = damage

func get_game_manager() -> Node2D:
	return game_manager

func get_entity_manager() -> Node2D:
	return entity_manager

func get_player() -> Node2D:
	return player

func set_game_manager_ref(game_manager_ref: Node2D):
	game_manager = game_manager_ref

func set_entity_manager_ref(entity_manager_ref: Node2D):
	entity_manager = entity_manager_ref

func set_player_ref(player_ref: Node2D):
	player = player_ref

func set_invulnerability_timer(timer: float):
	player_invulnerability_timer = timer

func get_invulnerability_timer() -> float:
	return player_invulnerability_timer

func set_player_invulnerability_timer(timer: float):
	player_invulnerability_timer = timer

func get_entity_interaction_settings() -> Dictionary:
	# Get interaction settings
	return {
		"damage_multiplier": damage_multiplier,
		"detection_range": detection_range,
		"attack_range": attack_range,
		"attack_cooldown": attack_cooldown,
		"player_damage": player_damage,
		"entity_damage": entity_damage
	}

func set_entity_interaction_settings(settings: Dictionary):
	# Set interaction settings
	for key in settings.keys():
		match key:
			"damage_multiplier":
				damage_multiplier = settings[key]
			"detection_range":
				detection_range = settings[key]
			"attack_range":
				attack_range = settings[key]
			"attack_cooldown":
				attack_cooldown = settings[key]
			"player_damage":
				player_damage = settings[key]
			"entity_damage":
				entity_damage = settings[key]

func get_entity_interaction_properties() -> Dictionary:
	# Get interaction properties
	return {
		"player_health": player_health,
		"player_max_health": player_max_health,
		"player_invulnerable": player_invulnerable,
		"player_invulnerability_timer": player_invulnerability_timer,
		"damage_multiplier": damage_multiplier,
		"detection_range": detection_range,
		"attack_range": attack_range,
		"attack_cooldown": attack_cooldown,
		"player_damage": player_damage,
		"entity_damage": entity_damage
	}

func set_entity_interaction_properties(properties: Dictionary):
	# Set interaction properties
	for key in properties.keys():
		match key:
			"player_health":
				player_health = properties[key]
			"player_max_health":
				player_max_health = properties[key]
			"player_invulnerable":
				player_invulnerable = properties[key]
			"player_invulnerability_timer":
				player_invulnerability_timer = properties[key]
			"damage_multiplier":
				damage_multiplier = properties[key]
			"detection_range":
				detection_range = properties[key]
			"attack_range":
				attack_range = properties[key]
			"attack_cooldown":
				attack_cooldown = properties[key]
			"player_damage":
				player_damage = properties[key]
			"entity_damage":
				entity_damage = properties[key]

func get_entity_interaction_stats() -> Dictionary:
	# Get interaction statistics
	return {
		"player_health": player_health,
		"player_max_health": player_max_health,
		"player_invulnerable": player_invulnerable,
		"player_invulnerability_timer": player_invulnerability_timer,
		"damage_multiplier": damage_multiplier,
		"detection_range": detection_range,
		"attack_range": attack_range,
		"attack_cooldown": attack_cooldown,
		"player_damage": player_damage,
		"entity_damage": entity_damage
	}

func set_entity_interaction_stats(stats: Dictionary):
	# Set interaction statistics
	for key in stats.keys():
		match key:
			"player_health":
				player_health = stats[key]
			"player_max_health":
				player_max_health = stats[key]
			"player_invulnerable":
				player_invulnerable = stats[key]
			"player_invulnerability_timer":
				player_invulnerability_timer = stats[key]
			"damage_multiplier":
				damage_multiplier = stats[key]
			"detection_range":
				detection_range = stats[key]
			"attack_range":
				attack_range = stats[key]
			"attack_cooldown":
				attack_cooldown = stats[key]
			"player_damage":
				player_damage = stats[key]
			"entity_damage":
				entity_damage = stats[key]

func is_player_invulnerable() -> bool:
	return player_invulnerable

func is_entity_interaction_system_active() -> bool:
	# Check if interaction system is active
	return is_inside_tree()

func set_entity_interaction_system_active(active: bool):
	# Set interaction system active state
	if active:
		set_process(true)
	else:
		set_process(false)

func handle_entity_detection(entity: Node2D):
	# Handle entity detection
	if entity == null or player == null:
		return
	
	# Check if entity is alive
	if not entity.is_alive():
		return
	
	# Check distance
	var distance = entity.position.distance_to(player.position)
	
	# Set detection
	if distance <= detection_range:
		entity.set_detected(true)
		emit_signal("entity_detected", entity, player)
	else:
		entity.set_detected(false)
		emit_signal("entity_undetected", entity)

func handle_entity_attack(entity: Node2D):
	# Handle entity attack
	if entity == null or player == null:
		return
	
	# Check if entity is alive
	if not entity.is_alive():
		return
	
	# Check if entity is detected
	if not entity.is_detected():
		return
	
	# Check distance
	var distance = entity.position.distance_to(player.position)
	
	# Attack if in range
	if distance <= attack_range:
		# Get damage
		var damage = entity.get_attack_damage() * damage_multiplier
		
		# Deal damage to player
		take_player_damage(damage)
		
		# Emit signal
		emit_signal("entity_attacked", entity, player, damage)

func handle_player_attack():
	# Handle player attack (if player has attack method)
	if player == null:
		return
	
	# Check if player has attack method
	if player.has_method("attack"):
		# Attack nearby entities
		var nearby_entities = entity_manager.get_entities_in_range(player.position, attack_range)
		
		for entity in nearby_entities:
			if entity.is_alive():
				# Deal damage to entity
				deal_player_damage(entity)

func get_entity_interaction_system_settings() -> Dictionary:
	# Get interaction system settings
	return {
		"damage_multiplier": damage_multiplier,
		"detection_range": detection_range,
		"attack_range": attack_range,
		"attack_cooldown": attack_cooldown,
		"player_damage": player_damage,
		"entity_damage": entity_damage
	}

func set_entity_interaction_system_settings(settings: Dictionary):
	# Set interaction system settings
	for key in settings.keys():
		match key:
			"damage_multiplier":
				damage_multiplier = settings[key]
			"detection_range":
				detection_range = settings[key]
			"attack_range":
				attack_range = settings[key]
			"attack_cooldown":
				attack_cooldown = settings[key]
			"player_damage":
				player_damage = settings[key]
			"entity_damage":
				entity_damage = settings[key]

func get_entity_interaction_system_properties() -> Dictionary:
	# Get interaction system properties
	return {
		"player_health": player_health,
		"player_max_health": player_max_health,
		"player_invulnerable": player_invulnerable,
		"player_invulnerability_timer": player_invulnerability_timer,
		"damage_multiplier": damage_multiplier,
		"detection_range": detection_range,
		"attack_range": attack_range,
		"attack_cooldown": attack_cooldown,
		"player_damage": player_damage,
		"entity_damage": entity_damage
	}

func set_entity_interaction_system_properties(properties: Dictionary):
	# Set interaction system properties
	for key in properties.keys():
		match key:
			"player_health":
				player_health = properties[key]
			"player_max_health":
				player_max_health = properties[key]
			"player_invulnerable":
				player_invulnerable = properties[key]
			"player_invulnerability_timer":
				player_invulnerability_timer = properties[key]
			"damage_multiplier":
				damage_multiplier = properties[key]
			"detection_range":
				detection_range = properties[key]
			"attack_range":
				attack_range = properties[key]
			"attack_cooldown":
				attack_cooldown = properties[key]
			"player_damage":
				player_damage = properties[key]
			"entity_damage":
				entity_damage = properties[key]

func get_entity_interaction_system_stats() -> Dictionary:
	# Get interaction system statistics
	return {
		"player_health": player_health,
		"player_max_health": player_max_health,
		"player_invulnerable": player_invulnerable,
		"player_invulnerability_timer": player_invulnerability_timer,
		"damage_multiplier": damage_multiplier,
		"detection_range": detection_range,
		"attack_range": attack_range,
		"attack_cooldown": attack_cooldown,
		"player_damage": player_damage,
		"entity_damage": entity_damage
	}

func set_entity_interaction_system_stats(stats: Dictionary):
	# Set interaction system statistics
	for key in stats.keys():
		match key:
			"player_health":
				player_health = stats[key]
			"player_max_health":
				player_max_health = stats[key]
			"player_invulnerable":
				player_invulnerable = stats[key]
			"player_invulnerability_timer":
				player_invulnerability_timer = stats[key]
			"damage_multiplier":
				damage_multiplier = stats[key]
			"detection_range":
				detection_range = stats[key]
			"attack_range":
				attack_range = stats[key]
			"attack_cooldown":
				attack_cooldown = stats[key]
			"player_damage":
				player_damage = stats[key]
			"entity_damage":
				entity_damage = stats[key]