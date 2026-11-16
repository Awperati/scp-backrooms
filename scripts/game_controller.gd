extends Node

# Game state management
var game_state: String = "TITLE"  # TITLE, PLAYING, PAUSED, GAME_OVER, VICTORY
var score: int = 0
var level: int = 1
var player_health: float = 100.0
var player_sanity: float = 100.0
var collected_drives: int = 0
var required_drives: int = 2

# Entity management
var entities: Array[Node] = []

func initialize():
	# Initialize game state
	game_state = "TITLE"
	
	# Initialize player stats
	player_health = 100.0
	player_sanity = 100.0
	collected_drives = 0

func update(delta):
	# Update game state logic
	match game_state:
		"PLAYING":
			update_gameplay(delta)
		"PAUSED":
			update_pause(delta)
		"GAME_OVER":
			update_game_over(delta)
		"VICTORY":
			update_victory(delta)

func update_gameplay(delta):
	# Check win condition
	if collected_drives >= required_drives:
		game_state = "VICTORY"

func update_pause(delta):
	# Pause logic
	pass

func update_game_over(delta):
	# Game over logic
	pass

func update_victory(delta):
	# Victory logic
	pass

func start_game():
	game_state = "PLAYING"

func pause_game():
	game_state = "PAUSED"

func resume_game():
	game_state = "PLAYING"

func game_over():
	game_state = "GAME_OVER"

func victory():
	game_state = "VICTORY"

func add_entity(entity: Node):
	entities.append(entity)

func remove_entity(entity: Node):
	entities.erase(entity)

func get_entities_by_type(entity_type: String) -> Array[Node]:
	var result: Array[Node] = []
	for ent in entities:
		if ent.entity_type == entity_type:
			result.append(ent)
	return result

func collect_drive():
	collected_drives += 1

func take_damage(amount: float):
	player_health -= amount
	if player_health <= 0:
		player_health = 0
		game_over()

func restore_health(amount: float):
	player_health = min(player_health + amount, 100.0)

func reduce_sanity(amount: float):
	player_sanity -= amount
	if player_sanity <= 0:
		player_sanity = 0
		game_over()

func restore_sanity(amount: float):
	player_sanity = min(player_sanity + amount, 100.0)