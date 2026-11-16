extends Node2D

# Data drive for 2D levels
@export var is_collected = false
@export var drive_id = 0

func _ready():
	add_to_group("data_drive")

func collect():
	if not is_collected:
		is_collected = true
		# Play collection sound
		if $AudioStreamPlayer:
			$AudioStreamPlayer.play()
		# Hide the drive
		$Sprite.hide()
		# Notify level manager
		get_parent().get_parent().collect_data_drive(self)