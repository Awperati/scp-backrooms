extends Node

# Inventory manager for the SCP Backrooms game.
# Tracks collected items: data drives, keys, etc.

signal item_added(item_name: String)
signal item_removed(item_name: String)
signal inventory_changed()

# Dictionary: item_name -> count
var items: Dictionary = {}
# Ordered list of item names for display
var item_order: Array[String] = []

# Maximum number of each item type
const MAX_DATA_DRIVES = 5
const MAX_KEYS = 3

func _ready():
	add_to_group("inventory")

func add_item(item_name: String, count: int = 1) -> bool:
	# Check if item is already tracked
	if items.has(item_name):
		items[item_name] += count
	else:
		items[item_name] = count
		item_order.append(item_name)
	item_added.emit(item_name)
	inventory_changed.emit()
	return true

func remove_item(item_name: String, count: int = 1) -> bool:
	if not items.has(item_name) or items[item_name] < count:
		return false
	items[item_name] -= count
	if items[item_name] == 0:
		items.erase(item_name)
		item_order.erase(item_name)
	item_removed.emit(item_name)
	inventory_changed.emit()
	return true

func has_item(item_name: String) -> bool:
	return items.has(item_name) and items[item_name] > 0

func get_count(item_name: String) -> int:
	if items.has(item_name):
		return items[item_name]
	return 0

func get_item_list() -> Array[String]:
	return item_order.duplicate()

func get_inventory_string() -> String:
	if item_order.is_empty():
		return "Empty"
	var lines: Array[String] = []
	for name in item_order:
		if items[name] > 1:
			lines.append("%s x%d" % [name, items[name]])
		else:
			lines.append(name)
	return "\n".join(lines)

func clear_inventory():
	items.clear()
	item_order.clear()
	inventory_changed.emit()

func reset():
	clear_inventory()
	data_drives_collected = 0

var data_drives_collected: int = 0

func collect_data_drive() -> bool:
	data_drives_collected += 1
	add_item("Data Drive")
	return true
