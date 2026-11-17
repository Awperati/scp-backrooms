extends "res://scripts/entity_base_2d.gd"

# Hound — fast, aggressive, patrols between fixed points
@export var detection_range: float = 12.0
@export var attack_range: float = 2.0
@export var attack_damage: float = 35.0
@export var speed: float = 4.0
@export var attack_cooldown: float = 1.0
@export var patrol_points: Array[Vector2] = [
	Vector2(-100, -100),
	Vector2(100, -100),
	Vector2(100, 100),
	Vector2(-100, 100),
]

var current_patrol_index: int = 0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	super._ready()
	entity_type = "HOUND"
	max_health = 200.0
	health = max_health
	current_patrol_index = 0
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
	else:
		_patrol(delta)

func _patrol(delta: float):
	if patrol_points.size() == 0:
		return
	var target = patrol_points[current_patrol_index]
	var dist_to_target = global_position.distance_to(target)
	if dist_to_target < 20.0:
		current_patrol_index = (current_patrol_index + 1) % patrol_points.size()
		target = patrol_points[current_patrol_index]
	move_towards(target, delta)

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
	await get_tree().create_timer(0.3).timeout
	is_attacking = false

func _on_entity_damaged(_entity, _amount):
	if animation_player.has_animation("damage"):
		animation_player.play("damage")

func _on_entity_destroyed(_entity):
	if animation_player.has_animation("death"):
		animation_player.play("death")
	queue_free()
