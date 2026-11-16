## Victory screen controller
extends Node

# UI elements
@onready var restart_button = $MarginContainer/VBoxContainer/RestartButton
@onready var main_menu_button = $MarginContainer/VBoxContainer/MainMenuButton
@onready var victory_label = $MarginContainer/VBoxContainer/VictoryLabel

func _ready() -> void:
	# Setup UI
	setup_ui()

func setup_ui() -> void:
	# Connect button signals
	restart_button.connect("pressed", self, "_on_restart_button_pressed")
	main_menu_button.connect("pressed", self, "_on_main_menu_button_pressed")

func _on_restart_button_pressed() -> void:
	# Restart the game
	print("Restarting game")
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_main_menu_button_pressed() -> void:
	# Return to main menu
	print("Returning to main menu")
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")

func _on_victory_opened() -> void:
	# Victory screen opened
	print("Victory screen opened")

func _on_victory_closed() -> void:
	# Victory screen closed
	print("Victory screen closed")