extends Node3D

# Level manager for SCP Backrooms
# Handles level transitions, data drive collection, and exit logic

@onready var data_drives = []
@onready var exit_door = null
@onready var level_name = "Level 0"
@onready var required_drives = 1

func _ready():
	# Find all data drives in this level
	data_drives = get_tree().get_nodes_in_group("data_drive")
	# Find exit door
	exit_door = get_node("ExitDoor")
	
	# Initialize level
	print("Level loaded: " + level_name)
	
	# Update UI
	if GameManager.instance:
		GameManager.instance.update_level_info(level_name, required_drives)
		GameManager.instance.update_drives_collected(data_drives.size())

func _process(delta):
	# Check if all data drives are collected
	if data_drives.size() > 0:
		var collected = 0
		for drive in data_drives:
			if drive.is_collected:
				collected += 1
		# Update UI
		if GameManager.instance:
			GameManager.instance.update_drives_collected(collected)
	
	# Check exit condition
	if exit_door and exit_door.is_active():
		if data_drives.size() > 0:
			var collected = 0
			for drive in data_drives:
				if drive.is_collected:
					collected += 1
			if collected >= required_drives:
				# Player can exit
				if GameManager.instance:
					GameManager.instance.complete_level()

func collect_data_drive(drive):
	# Handle data drive collection
	if GameManager.instance:
		GameManager.instance.collect_data_drive()