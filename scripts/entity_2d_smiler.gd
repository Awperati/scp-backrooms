extends "res://scripts/entity_base_2d.gd"

# Smiler — slow, melee, visible
@export var detection_range: float = 8.0
@export var attack_range: float = 1.5
@export var attack_damage: float = 25.0
@export var speed: float = 2.0
@export var attack_cooldown: float = 2.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	super._ready()
	entity_type = "SMILER"
	max_health = 100.0
	health = max_health
	entity_damaged.connect(_on_entity_damaged)
	entity_destroyed.connect(_on_entity_destroyed)

func update_entity(delta: float):
	if player == null or not is_alive:
		return
	var dist = global_position.distance_to(player.global_position)
	if dist <= attack_range:
		_try_attack()
	elif dist <= detection_range:
		move_towards(player.global_position, delta)

func _try_attack():
	var now = Time.get_ticks_msec() / 1000.0
	if now - last_attack_time < attack_cooldown:
		return
	last_attack_time = now
	is_attacking = true
	player.take_damage(attack_damage)
	entity_attacked.emit(self, player, attack_damage)
	if animation_player.has_animation("attack"):
		animation_player.play("attack")
	# Reset attacking flag after a short delay
	await get_tree().create_timer(0.3).timeout
	is_attacking = false

func _on_entity_damaged(_entity, _amount):
	if animation_player.has_animation("damage"):
		animation_player.play("damage")

func _on_entity_destroyed(_entity):
	if animation_player.has_animation("death"):
		animation_player.play("death")
	queue_free()
