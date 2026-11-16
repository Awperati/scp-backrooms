## UI manager. Updates sanity bar, inventory display, title/game over screens.
extends CanvasLayer

func _ready() -> void:
	GameController.sanity_changed.connect(_on_sanity_changed)
	GameController.game_over_emitted.connect(_on_game_over)

func _process(_delta: float) -> void:
	_update_sanity_bar()
	_update_inventory()

func _update_sanity_bar() -> void:
	var sanity_progress = $SanityBar/SanityProgress
	if sanity_progress:
		sanity_progress.value = GameController.sanity

func _update_inventory() -> void:
	var inv_label = $Inventory/InvItems
	if inv_label:
		if GameController.inventory.size() > 0:
			inv_label.text = "\n".join(GameController.inventory)
		else:
			inv_label.text = "Empty"

func _on_sanity_changed(value: float) -> void:
	var sanity_progress = $SanityBar/SanityProgress
	if sanity_progress:
		sanity_progress.value = value

func _on_game_over() -> void:
	var title = $TitleScreen
	if title:
		title.text = "GAME OVER\nPress F to restart"
		title.visible = true
