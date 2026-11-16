extends "res://scripts/entity.gd"

@export var detection_range: float = 8.0
@export var attack_range: float = 1.5
@export var damage: float = 25.0

func _ready():
	super._ready()
	entity_type = "HOUND"
	health = 100
	max_health = 100
	speed = 2.5
	detection_range = 8.0
	attack_range = 1.5
	damage = 25.0

func _process(delta):
	if not is_active:
		return
		
	if player == null:
		player = get_tree().get_nodes_in_group("player")[0] as Node3D
		
	# Check if player is in detection range
	var distance_to_player = position.distance_to(player.position)
	
	if distance_to_player <= detection_range:
		# Face player
		var direction = (player.position - position).normalized()
		look_at(player.position, Vector3.UP)
		
		# Move towards player if not in attack range
		if distance_to_player > attack_range:
			velocity = direction * speed
			move_and_slide()
		else:
			# Attack player
			attack_player()
	
func attack_player():
	# Damage player when in attack range
	if player != null:
		var player_controller = player.get_script()
		if player_controller != null:
			player_controller.take_damage(damage)