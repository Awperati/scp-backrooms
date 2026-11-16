extends StaticBody3D

# Data drive script for SCP Backrooms game
# Represents a data drive that can be collected by the player

@export var drive_id: int = 0
@export var is_collected: bool = false

func _ready():
	# Initialize the data drive
	pass

func collect_drive():
	# Handle collecting the drive
	if not is_collected:
		is_collected = true
		print("Data drive %d collected!" % drive_id)
		# In a real game, this would trigger visual effects and update the UI
		return true
	return false