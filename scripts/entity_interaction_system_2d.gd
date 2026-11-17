extends Node2D

# Entity Interaction System — player-entity collisions, damage, detection.

var game_manager: Node2D = null
var entity_manager: Node2D = null
var player: Node2D = null

var player_health: float = 100.0
var player_max_health: float = 100.0
var player_invulnerable: bool = false
var player_invulnerability_timer: float = 0.0

@export var damage_multiplier: float = 1.0
@export var detection_range: float = 100.0
@export var attack_range: float = 50.0
@export var attack_cooldown: float = 1.0
@export var player_damage: float = 25.0

signal player_damage_taken(p, amount)
signal player_damage_dealt(p, amount)
signal entity_damage_taken(e, amount)
signal entity_damage_dealt(e, target, amount)
signal entity_detected(e, p)
signal entity_undetected(e)
signal entity_attacked(e, target, damage)
signal player_attacked(p, e, damage)
signal player_died(p)
signal player_healed(p, amount)
signal collision_detected(e, target, type)

func _ready():
	add_to_group("entity_interaction_system")

func set_game_manager(mgr: Node2D):
	game_manager = mgr

func set_entity_manager(mgr: Node2D):
	entity_manager = mgr

func set_player(p: Node2D):
	player = p
	if p != null:
		player_health = p.health
		player_max_health = p.max_health

func _process(delta):
	if player_invulnerable:
		player_invulnerability_timer -= delta
		if player_invulnerability_timer <= 0.0:
			player_invulnerable = false

func handle_player_entity_collision(p: Node2D, e: Node2D):
	if p == null or e == null or not e.is_alive or player_invulnerable:
		return
	var damage = e.get_attack_damage() * damage_multiplier
	take_player_damage(damage)

func take_player_damage(amount: float):
	if player == null or player_invulnerable:
		return
	player_health -= amount
	if player.has_method("take_damage"):
		player.take_damage(amount)
	player_damage_taken.emit(player, amount)
	if player_health <= 0.0:
		player_health = 0.0
		player_died.emit(player)

func take_entity_damage(e: Node2D, amount: float):
	if e == null or not e.has_method("take_damage"):
		return
	e.take_damage(amount)
	entity_damage_taken.emit(e, amount)

func heal_player(amount: float):
	if player == null or not player.has_method("heal"):
		return
	player_health = min(player_health + amount, player_max_health)
	player.heal(amount)
	player_healed.emit(player, amount)

func set_player_invulnerable(inv: bool):
	player_invulnerable = inv
	if inv:
		player_invulnerability_timer = 0.8

func get_player_health() -> float:
	return player_health

func get_player_max_health() -> float:
	return player_max_health

func get_player_invulnerable() -> bool:
	return player_invulnerable
