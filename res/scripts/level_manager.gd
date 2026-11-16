extends Node3D

# Level manager for SCP Backrooms game
# Handles level transitions and management

@export var current_level: int = 0
@export var next_level: int = 1

func _ready():
	# Initialize level manager
	pass

func transition_to_level(level_number: int):
	# Handle transition to a specific level
	print("Transitioning to level %d" % level_number)
	
	# In a real game, this would load the appropriate scene
	# and handle any necessary setup
	
	current_level = level_number