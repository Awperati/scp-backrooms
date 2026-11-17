extends "res://scripts/entity_base_2d.gd"

# Floating — hovers, slow, moderate damage
@export var detection_range: float = 10.0
@export var attack_range: float = 2.0
@export var attack_damage: float = 30.0
@export var speed: float = 2.0
@export var attack_cooldown: float = 2.5
@export var hover_speed: float = 1.0

var hover_offset: float = 0.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	super._ready()
	entity_type = "FLOATING"
	max_health = 150.0
	health = max_health
	entity_damaged.connect(_on_entity_damaged)
	entity_destroyed.connect(_on_entity_destroyed)

func update_entity(delta: float):
	# Hover bob
	hover_offset += delta * hover_speed
	position.y += sin(hover_offset) * 0.5

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
	await get_tree().create_timer(0.4).timeout
	is_attacking = false

func _on_entity_damaged(_entity, _amount):
	if animation_player.has_animation("damage"):
		animation_player.play("damage")

func _on_entity_destroyed(_entity):
	if animation_player.has_animation("death"):
		animation_player.play("death")
	queue_free()
