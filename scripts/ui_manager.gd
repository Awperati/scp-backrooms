## UI manager. Updates health bar, sanity bar, inventory display, title/game over screens.
extends CanvasLayer

func _ready() -> void:
	GameController.sanity_changed.connect(_on_sanity_changed)
	GameController.health_changed.connect(_on_health_changed)
	GameController.game_over_emitted.connect(_on_game_over)

func _process(_delta: float) -> void:
	_update_health_bar()
	_update_sanity_bar()
	_update_inventory()

func _update_health_bar() -> void:
	var hp = $HealthBar/HealthProgress
	if hp:
		hp.value = GameController.health

func _update_sanity_bar() -> void:
	var sp = $SanityBar/SanityProgress
	if sp:
		sp.value = GameController.sanity

func _update_inventory() -> void:
	var inv = $Inventory/VBox/InvItems
	if inv:
		if GameController.inventory.size() > 0:
			inv.text = "\n".join(GameController.inventory)
		else:
			inv.text = "Empty"

func _on_health_changed(value: float) -> void:
	var hp = $HealthBar/HealthProgress
	if hp:
		hp.value = value

func _on_sanity_changed(value: float) -> void:
	var sp = $SanityBar/SanityProgress
	if sp:
		sp.value = value

func _on_game_over() -> void:
	var title = $TitleScreen
	if title:
		title.text = "GAME OVER\nPress F to restart"
		title.visible = true
