extends Node2D

# Particle System — ambient, enemy, player particles.

@export var particle_count: int = 100
@export var atmosphere_intensity: float = 1.0

var game_manager: Node2D = null
var player: Node2D = null

var particle_emitters: Array[CPUParticles2D] = []

signal particle_emitted(type)
signal atmosphere_changed(intensity)

func _ready():
	add_to_group("particle_system")
	_create_emitters()

func _create_emitters():
	# Ambient dust
	var dust = CPUParticles2D.new()
	dust.name = "AmbientDust"
	dust.amount = 50
	dust.lifetime = 3.0
	dust.direction = Vector2(0, 1)
	dust.spread = 10.0
	dust.initial_velocity_min = 5.0
	dust.initial_velocity_max = 15.0
	dust.scale_amount_min = 0.5
	dust.scale_amount_max = 1.0
	dust.color_initial = Color(0.8, 0.8, 0.6, 0.3)
	add_child(dust)
	particle_emitters.append(dust)

	# Enemy particles (red glow)
	var enemy = CPUParticles2D.new()
	enemy.name = "EnemyGlow"
	enemy.amount = 20
	enemy.lifetime = 1.0
	enemy.spread = 180.0
	enemy.initial_velocity_min = 10.0
	enemy.initial_velocity_max = 30.0
	enemy.scale_amount_min = 0.3
	enemy.scale_amount_max = 0.8
	enemy.color_initial = Color(1.0, 0.2, 0.2, 0.5)
	enemy.emitting = false
	add_child(enemy)
	particle_emitters.append(enemy)

func set_game_manager(mgr: Node2D):
	game_manager = mgr

func set_player(p: Node2D):
	player = p

func emit_particles(particle_type: String, position: Vector2):
	if particle_type == "enemy":
		var emitter = particle_emitters[1]
		emitter.global_position = position
		emitter.emitting = true
		await get_tree().create_timer(1.0).timeout
		emitter.emitting = false
	particle_emitted.emit(particle_type)

func set_atmosphere_intensity(v: float):
	atmosphere_intensity = v
	if particle_emitters.size() > 0:
		particle_emitters[0].amount = int(50 * v)
	atmosphere_changed.emit(v)
