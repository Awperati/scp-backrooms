extends Node2D

# UI System for SCP Backrooms - 2D version
# Handles all user interface elements and displays

# UI elements
var ui_elements = {}

# Game references
var game_manager: Node2D = null
var player: Node2D = null
var entity_interaction_system: Node2D = null

# UI settings
@export var show_debug_info: bool = false
@export var show_health_bar: bool = true
@export var show_level_info: bool = true
@export var show_entity_count: bool = true

# Signals
signal ui_element_created(element_name)
signal ui_element_updated(element_name)
signal ui_element_destroyed(element_name)

func _ready():
	# Initialize UI system
	add_to_group("ui_system")
	
	# Setup UI elements
	setup_ui_elements()
	
	# Connect to game manager
	connect_to_game_manager()

func setup_ui_elements():
	# Create main UI elements
	create_ui_element("health_bar", preload("res://scenes/ui/health_bar.tscn"))
	create_ui_element("level_info", preload("res://scenes/ui/level_info.tscn"))
	create_ui_element("entity_count", preload("res://scenes/ui/entity_count.tscn"))
	create_ui_element("start_menu", preload("res://scenes/ui/start_menu.tscn"))
	create_ui_element("pause_menu", preload("res://scenes/ui/pause_menu.tscn"))
	create_ui_element("game_over", preload("res://scenes/ui/game_over.tscn"))
	create_ui_element("level_complete", preload("res://scenes/ui/level_complete.tscn"))

func create_ui_element(element_name: String, scene_path: PackedScene):
	# Create a UI element
	var ui_element = scene_path.instantiate()
	ui_element.name = element_name + "_ui"
	
	# Add to scene
	add_child(ui_element)
	
	# Store reference
	ui_elements[element_name] = ui_element
	
	# Emit signal
	emit_signal("ui_element_created", element_name)

func set_game_manager(new_game_manager: Node2D):
	game_manager = new_game_manager
	
	# Connect to game manager
	connect_to_game_manager()

func connect_to_game_manager():
	if game_manager != null:
		game_manager.connect("game_started", self, "on_game_started")
		game_manager.connect("game_paused", self, "on_game_paused")
		game_manager.connect("game_resumed", self, "on_game_resumed")
		game_manager.connect("game_over", self, "on_game_over")
		game_manager.connect("level_loaded", self, "on_level_loaded")
		game_manager.connect("level_completed", self, "on_level_completed")

func on_game_started():
	# Called when game starts
	# Show start menu
	show_ui_element("start_menu")
	
	# Hide other UI elements
	hide_all_ui_elements()

func on_game_paused():
	# Called when game pauses
	# Show pause menu
	show_ui_element("pause_menu")

func on_game_resumed():
	# Called when game resumes
	# Hide pause menu
	hide_ui_element("pause_menu")

func on_game_over():
	# Called when game ends
	# Show game over screen
	show_ui_element("game_over")

func on_level_loaded(level: int):
	# Called when level loads
	# Update level info
	update_level_info(level)
	
	# Show level info
	if show_level_info:
		show_ui_element("level_info")

func on_level_completed(level: int):
	# Called when level completes
	# Show level complete screen
	show_ui_element("level_complete")

func set_player(new_player: Node2D):
	player = new_player

func set_entity_interaction_system(new_interaction_system: Node2D):
	entity_interaction_system = new_interaction_system

func update_ui():
	# Update all UI elements
	update_health_bar()
	update_level_info()
	update_entity_count()

func update_health_bar():
	# Update health bar
	if not show_health_bar:
		return
	
	if entity_interaction_system != null and player != null:
		var health = entity_interaction_system.get_player_health()
		var max_health = entity_interaction_system.get_player_max_health()
		
		# Update health bar
		if ui_elements.has("health_bar"):
			var health_bar = ui_elements["health_bar"]
			
			# Set health value
			if health_bar.has_method("set_health"):
				health_bar.set_health(health, max_health)

func update_level_info(level: int = -1):
	# Update level information
	if not show_level_info:
		return
	
	if level == -1:
		if game_manager != null:
			level = game_manager.get_current_level()
	
	if ui_elements.has("level_info"):
		var level_info = ui_elements["level_info"]
		
		# Update level info
		if level_info.has_method("set_level_info"):
			level_info.set_level_info(level)

func update_entity_count():
	# Update entity count
	if not show_entity_count:
		return
	
	if game_manager != null and game_manager.get_entity_manager() != null:
		var entity_manager = game_manager.get_entity_manager()
		
		# Get entity count
		var entity_count = entity_manager.get_entity_count()
		
		# Update entity count UI
		if ui_elements.has("entity_count"):
			var entity_count_ui = ui_elements["entity_count"]
			
			# Set entity count
			if entity_count_ui.has_method("set_entity_count"):
				entity_count_ui.set_entity_count(entity_count)

func show_ui_element(element_name: String):
	# Show a UI element
	if ui_elements.has(element_name):
		var element = ui_elements[element_name]
		
		# Show element
		if element != null:
			element.show()
			
			# Emit signal
			emit_signal("ui_element_updated", element_name)

func hide_ui_element(element_name: String):
	# Hide a UI element
	if ui_elements.has(element_name):
		var element = ui_elements[element_name]
		
		# Hide element
		if element != null:
			element.hide()
			
			# Emit signal
			emit_signal("ui_element_updated", element_name)

func show_all_ui_elements():
	# Show all UI elements
	for element_name in ui_elements.keys():
		show_ui_element(element_name)

func hide_all_ui_elements():
	# Hide all UI elements
	for element_name in ui_elements.keys():
		hide_ui_element(element_name)

func toggle_ui_element(element_name: String):
	# Toggle a UI element visibility
	if ui_elements.has(element_name):
		var element = ui_elements[element_name]
		
		# Toggle visibility
		if element != null:
			if element.visible:
				hide_ui_element(element_name)
			else:
				show_ui_element(element_name)

func get_ui_element(element_name: String) -> Node2D:
	# Get a UI element
	if ui_elements.has(element_name):
		return ui_elements[element_name]
	return null

func set_ui_element(element_name: String, element: Node2D):
	# Set a UI element
	ui_elements[element_name] = element
	
	# Add to scene
	if element != null:
		add_child(element)
	
	# Emit signal
	emit_signal("ui_element_created", element_name)

func remove_ui_element(element_name: String):
	# Remove a UI element
	if ui_elements.has(element_name):
		var element = ui_elements[element_name]
		
		# Remove from scene
		if element != null:
			remove_child(element)
		
		# Remove reference
		ui_elements.erase(element_name)
		
		# Emit signal
		emit_signal("ui_element_destroyed", element_name)

func get_ui_elements() -> Dictionary:
	# Get all UI elements
	return ui_elements

func set_ui_elements(elements: Dictionary):
	# Set all UI elements
	ui_elements = elements

func get_ui_settings() -> Dictionary:
	# Get UI settings
	return {
		"show_debug_info": show_debug_info,
		"show_health_bar": show_health_bar,
		"show_level_info": show_level_info,
		"show_entity_count": show_entity_count
	}

func set_ui_settings(settings: Dictionary):
	# Set UI settings
	for key in settings.keys():
		match key:
			"show_debug_info":
				show_debug_info = settings[key]
			"show_health_bar":
				show_health_bar = settings[key]
			"show_level_info":
				show_level_info = settings[key]
			"show_entity_count":
				show_entity_count = settings[key]

func set_show_debug_info(enabled: bool):
	show_debug_info = enabled

func set_show_health_bar(enabled: bool):
	show_health_bar = enabled

func set_show_level_info(enabled: bool):
	show_level_info = enabled

func set_show_entity_count(enabled: bool):
	show_entity_count = enabled

func is_debug_info_visible() -> bool:
	return show_debug_info

func is_health_bar_visible() -> bool:
	return show_health_bar

func is_level_info_visible() -> bool:
	return show_level_info

func is_entity_count_visible() -> bool:
	return show_entity_count

func update_ui_elements():
	# Update all UI elements
	update_health_bar()
	update_level_info()
	update_entity_count()

func set_game_manager_ref(game_manager_ref: Node2D):
	game_manager = game_manager_ref

func set_player_ref(player_ref: Node2D):
	player = player_ref

func set_entity_interaction_system_ref(interaction_system_ref: Node2D):
	entity_interaction_system = interaction_system_ref

func initialize_ui():
	# Initialize all UI elements
	show_all_ui_elements()

func destroy_ui():
	# Destroy all UI elements
	for element_name in ui_elements.keys():
		remove_ui_element(element_name)

func update_ui_visibility():
	# Update visibility of UI elements based on settings
	if show_health_bar:
		show_ui_element("health_bar")
	else:
		hide_ui_element("health_bar")
	
	if show_level_info:
		show_ui_element("level_info")
	else:
		hide_ui_element("level_info")
	
	if show_entity_count:
		show_ui_element("entity_count")
	else:
		hide_ui_element("entity_count")