## Title screen controller
extends Node

# UI elements
@onready var start_button = $MarginContainer/VBoxContainer/StartButton
@onready var quit_button = $MarginContainer/VBoxContainer/QuitButton
@onready var title_label = $MarginContainer/VBoxContainer/TitleLabel

func _ready() -> void:
	# Setup UI
	setup_ui()

func setup_ui() -> void:
	# Connect button signals
	start_button.connect("pressed", self, "_on_start_button_pressed")
	quit_button.connect("pressed", self, "_on_quit_button_pressed")

func _on_start_button_pressed() -> void:
	# Start the game
	print("Starting game")
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_quit_button_pressed() -> void:
	# Quit the game
	print("Quitting game")
	get_tree().quit()

func _on_title_screen_opened() -> void:
	# Title screen opened
	print("Title screen opened")

func _on_title_screen_closed() -> void:
	# Title screen closed
	print("Title screen closed")