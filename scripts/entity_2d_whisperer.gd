extends "res://scripts/entity_base_2d.gd"

# Whisperer — long range, slow attack, whispers periodically
@export var detection_range: float = 20.0
@export var attack_range: float = 4.0
@export var attack_damage: float = 50.0
@export var speed: float = 3.5
@export var attack_cooldown: float = 4.0
@export var whisper_interval: float = 5.0

var whisper_timer: float = 0.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal whispered(entity)

func _ready():
	super._ready()
	entity_type = "WHISPERER"
	max_health = 300.0
	health = max_health
	entity_damaged.connect(_on_entity_damaged)
	entity_destroyed.connect(_on_entity_destroyed)

func update_entity(delta: float):
	# Whisper periodically
	whisper_timer += delta
	if whisper_timer >= whisper_interval:
		whisper_timer = 0.0
		whispered.emit(self)
		if animation_player.has_animation("whisper"):
			animation_player.play("whisper")

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
	await get_tree().create_timer(0.5).timeout
	is_attacking = false

func _on_entity_damaged(_entity, _amount):
	if animation_player.has_animation("damage"):
		animation_player.play("damage")

func _on_entity_destroyed(_entity):
	if animation_player.has_animation("death"):
		animation_player.play("death")
	queue_free()
