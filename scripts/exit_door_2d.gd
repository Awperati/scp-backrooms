extends Node2D

# Exit door for 2D levels
@export var is_active = false
@export var required_drives = 2

func _ready():
	add_to_group("exit_door")

func is_active():
	return is_active

func activate():
	is_active = true
	# Change door appearance
	$Sprite.modulate = Color(1, 1, 1, 1)  # Make it visible

func _on_body_entered(body):
	if body.name == "Player":
		# Check if player has collected required drives
		var level_manager = get_parent().get_parent()
		if level_manager:
			var collected = 0
			for drive in level_manager.data_drives:
				if drive.is_collected:
					collected += 1
			if collected >= required_drives:
				# Activate door
				activate()