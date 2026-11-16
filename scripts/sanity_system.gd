extends Node

# Sanity system for the SCP Backrooms game

var sanity_level = 100.0
var max_sanity = 100.0
var sanity_decrease_rate = 0.1
var sanity_increase_rate = 0.5

func _ready():
	# Start the sanity decrease timer
	set_process(true)

func _process(delta):
	# Decrease sanity over time
	sanity_level -= sanity_decrease_rate * delta
	
	# Clamp sanity level between 0 and max
	sanity_level = clamp(sanity_level, 0, max_sanity)
	
	# Update UI or effects based on sanity level
	update_sanity_effects()

func update_sanity_effects():
	# Apply visual effects based on sanity level
	if sanity_level < 30:
		# Apply flicker effect
		emit_signal("sanity_low")
	elif sanity_level < 60:
		# Apply subtle effects
		emit_signal("sanity_medium")
	else:
		# Normal effects
		emit_signal("sanity_high")

func increase_sanity(amount):
	# Increase sanity
	sanity_level += amount
	sanity_level = clamp(sanity_level, 0, max_sanity)

func decrease_sanity(amount):
	# Decrease sanity
	sanity_level -= amount
	sanity_level = clamp(sanity_level, 0, max_sanity)

func add_sanity_effect(effect_name):
	# Add a sanity effect
	emit_signal("sanity_effect_added", effect_name)

func remove_sanity_effect(effect_name):
	# Remove a sanity effect
	emit_signal("sanity_effect_removed", effect_name)