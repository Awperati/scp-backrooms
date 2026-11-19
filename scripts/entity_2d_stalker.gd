extends "res://scripts/entity_base_2d.gd"

# Stalker — faster, more health, patrols when player is far
# (detection_range / attack_range / attack_damage / speed / attack_cooldown
#  come from entity_base_2d.gd and are set in _ready below.)

var idle_timer: float = 0.0
var is_patrolling: bool = true

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	super._ready()
	entity_type = "STALKER"
	max_health = 150.0
	health = max_health
	detection_range = 10.0
	attack_range = 1.0
	attack_damage = 30.0
	speed = 3.0
	attack_cooldown = 1.5
	entity_damaged.connect(_on_entity_damaged)
	entity_destroyed.connect(_on_entity_destroyed)

func update_entity(delta: float):
	idle_timer += delta
	if idle_timer > 3.0:
		is_patrolling = not is_patrolling
		idle_timer = 0.0

	if player == null or not is_alive:
		return
	var dist = global_position.distance_to(player.global_position)
	if dist <= attack_range:
		_try_attack()
	elif dist <= detection_range:
		move_towards(player.global_position, delta)
	elif is_patrolling:
		_patrol(delta)

func _patrol(delta: float):
	# Simple patrol: move in a small circle around current position
	var angle = Time.get_ticks_msec() / 1000.0 * 0.5
	var dir = Vector2.from_angle(angle)
	velocity = dir * speed * 0.5
	move_and_slide()
	rotation = dir.angle()

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
