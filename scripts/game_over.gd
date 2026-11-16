## Game over screen controller
extends Node

# UI elements
@onready var restart_button = $MarginContainer/VBoxContainer/RestartButton
@onready var main_menu_button = $MarginContainer/VBoxContainer/MainMenuButton
@onready var game_over_label = $MarginContainer/VBoxContainer/GameOverLabel

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

func _on_game_over_opened() -> void:
	# Game over screen opened
	print("Game over screen opened")

func _on_game_over_closed() -> void:
	# Game over screen closed
	print("Game over screen closed")