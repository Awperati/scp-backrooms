extends Node

# Particle Manager for SCP Backrooms game
# Handles all particle effects and visual feedback

# Particle effects
var footstep_particles: Particles3D = null
var damage_particles: Particles3D = null
var sanity_particles: Particles3D = null
var pickup_particles: Particles3D = null
var ambient_particles: Particles3D = null

# References
var player: Node = null
var game_controller: Node = null

func _ready():
	# Initialize particle systems
	setup_particles()
	
	# Find game objects
	player = get_tree().get_nodes_in_group("player")[0] if get_tree().get_nodes_in_group("player").size() > 0 else null
	game_controller = get_tree().get_nodes_in_group("game_controller")[0] if get_tree().get_nodes_in_group("game_controller").size() > 0 else null

func setup_particles():
	# Load particle resources
	footstep_particles = preload("res://scenes/particles/player_footsteps.tscn").instantiate()
	damage_particles = preload("res://scenes/particles/damage_effect.tscn").instantiate()
	sanity_particles = preload("res://scenes/particles/sanity_effect.tscn").instantiate()
	pickup_particles = preload("res://scenes/particles/pickup_effect.tscn").instantiate()
	ambient_particles = preload("res://scenes/particles/ambient_particles.tscn").instantiate()
	
	# Add to scene
	add_child(footstep_particles)
	add_child(damage_particles)
	add_child(sanity_particles)
	add_child(pickup_particles)
	add_child(ambient_particles)
	
	# Disable all particles initially
	footstep_particles.emitting = false
	damage_particles.emitting = false
	sanity_particles.emitting = false
	pickup_particles.emitting = false
	ambient_particles.emitting = false

func play_footstep_effect(position: Vector3):
	if footstep_particles != null:
		footstep_particles.position = position
		footstep_particles.emitting = true
		await get_tree().create_timer(0.2).timeout
		footstep_particles.emitting = false

func play_damage_effect(position: Vector3):
	if damage_particles != null:
		damage_particles.position = position
		damage_particles.emitting = true
		await get_tree().create_timer(0.5).timeout
		damage_particles.emitting = false

func play_sanity_effect(position: Vector3):
	if sanity_particles != null:
		sanity_particles.position = position
		sanity_particles.emitting = true
		await get_tree().create_timer(0.5).timeout
		sanity_particles.emitting = false

func play_pickup_effect(position: Vector3):
	if pickup_particles != null:
		pickup_particles.position = position
		pickup_particles.emitting = true
		await get_tree().create_timer(0.3).timeout
		pickup_particles.emitting = false

func play_ambient_effect():
	if ambient_particles != null:
		ambient_particles.emitting = true

func stop_ambient_effect():
	if ambient_particles != null:
		ambient_particles.emitting = false

func update_ambient_effects():
	# Update ambient effects based on player state
	if player != null and player.sanity != null:
		if player.sanity < 30:
			# More intense ambient effects when sanity is low
			if ambient_particles != null:
				ambient_particles.process_material.emitting = true
		else:
			if ambient_particles != null:
				ambient_particles.process_material.emitting = false