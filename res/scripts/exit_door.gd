extends Node3D

# Exit door script for SCP Backrooms game
# Handles door mechanics and level transitions

@export var required_drives: int = 2
@export var is_unlocked: bool = false
@export var is_open: bool = false

func _ready():
	# Initialize the exit door
	pass

func check_unlock():
	# Check if the door can be unlocked with collected drives
	# This would normally check the player's inventory
	print("Checking if door can be unlocked with %d drives" % required_drives)
	return is_unlocked

func open_door():
	# Open the door if unlocked
	if is_unlocked and not is_open:
		is_open = true
		print("Door opened!")
		# In a real game, this would trigger animations and sound effects
		return true
	return false