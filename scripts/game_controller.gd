## AutoLoad singleton. Game state manager.
extends Node

var sanity: float = 100.0
var inventory: Array = []
var current_level: int = 0
var game_over: bool = false

signal sanity_changed(new_value)
signal game_over_emitted

func lose_sanity(amount: float) -> void:
	sanity = maxf(0.0, sanity - amount)
	sanity_changed.emit(sanity)
	if sanity <= 0.0 and not game_over:
		game_over = true
		game_over_emitted.emit()

func add_sanity(amount: float) -> void:
	sanity = minf(100.0, sanity + amount)
	sanity_changed.emit(sanity)

func add_item(item: String) -> void:
	inventory.append(item)

func remove_item(item: String) -> void:
	if item in inventory:
		inventory.erase(item)

func has_item(item: String) -> bool:
	return item in inventory
