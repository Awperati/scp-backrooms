extends CharacterBody2D

# Base entity for SCP Backrooms 2D
# All entity types inherit from this class.

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

# Player reference — set by game manager on spawn
var player: Node2D = null

# Game references
var game_manager: Node2D = null
var entity_manager: Node2D = null
var entity_interaction_system: Node2D = null

# Visual settings
@export var animation_speed: float = 1.0
@export var sprite_scale: Vector2 = Vector2(1.0, 1.0)
@export var idle_animation: String = "idle"
@export var walk_animation: String = "walk"
@export var attack_animation: String = "attack"
@export var damage_animation: String = "damage"

signal entity_spawned(entity)
signal entity_destroyed(entity)
signal entity_damaged(entity, amount)
signal entity_attacked(entity, target, damage)
signal entity_detected(entity, detected)
signal entity_undetected(entity)

func _ready():
	add_to_group("entities")
	add_to_group(entity_type + "_entity")
	health = max_health
	entity_spawned.emit(self)

func _process(delta):
	update_entity(delta)

func update_entity(delta: float):
	# Override in child classes
	pass

func move_towards(target_position: Vector2, delta: float):
	if not is_alive:
		return
	var direction = (target_position - position).normalized()
	velocity = direction * speed
	move_and_slide()
	rotation = direction.angle()

func take_damage(amount: float):
	if not is_alive:
		return
	health -= amount
	entity_damaged.emit(self, amount)
	if health <= 0.0:
		health = 0.0
		is_alive = false
		entity_destroyed.emit(self)

func set_player(new_player: Node2D):
	player = new_player

func set_game_manager(new_game_manager: Node2D):
	game_manager = new_game_manager

func set_entity_manager(new_entity_manager: Node2D):
	entity_manager = new_entity_manager

func set_entity_interaction_system(new_interaction_system: Node2D):
	entity_interaction_system = new_interaction_system

func get_health() -> float:
	return health

func get_max_health() -> float:
	return max_health

func get_entity_type() -> String:
	return entity_type

func get_entity_name() -> String:
	return entity_name

func get_speed() -> float:
	return speed

func get_detection_range() -> float:
	return detection_range

func get_attack_range() -> float:
	return attack_range

func get_attack_damage() -> float:
	return attack_damage

func get_attack_cooldown() -> float:
	return attack_cooldown

func get_last_attack_time() -> float:
	return last_attack_time

func get_is_attacking() -> bool:
	return is_attacking

func get_game_manager() -> Node2D:
	return game_manager

func get_entity_manager() -> Node2D:
	return entity_manager

func get_entity_interaction_system() -> Node2D:
	return entity_interaction_system

func get_entity_properties() -> Dictionary:
	return {
		"name": entity_name,
		"type": entity_type,
		"health": health,
		"max_health": max_health,
		"speed": speed,
		"detection_range": detection_range,
		"attack_range": attack_range,
		"attack_damage": attack_damage,
		"attack_cooldown": attack_cooldown,
	}

func get_entity_settings() -> Dictionary:
	return {
		"animation_speed": animation_speed,
		"sprite_scale": sprite_scale,
		"idle_animation": idle_animation,
		"walk_animation": walk_animation,
		"attack_animation": attack_animation,
		"damage_animation": damage_animation,
	}

func get_entity_stats() -> Dictionary:
	return {
		"health": health,
		"max_health": max_health,
		"is_alive": is_alive,
		"is_detected": is_detected,
		"is_attacking": is_attacking,
	}
