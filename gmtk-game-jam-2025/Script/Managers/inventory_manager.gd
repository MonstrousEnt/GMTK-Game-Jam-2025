extends Node

@export var inventory: Array = []

# Adds an item to the inventory
func add_item(item: item_data):
	inventory.append(item)
	print("item added to inventory!", item.item_name)

# Uses an item from the inventory.
func use_item(id: int) -> void:
	if id < 0 or id >= inventory.size():
		return
	var item_to_use: item_data = inventory[id]
	item_to_use.use_item()
	# Remove the item after using it.
	remove_item(id)

# Remove an item from the inventory based on an id.
func remove_item(id: int):
	if id >= 0 and id < inventory.size():
		inventory.remove_at(id)
		print("item removed from inventory.")

# Returns items in inventory.
func get_items():
	return inventory
	
# Clears each item from the inventory.
func clear_inventory():
	inventory.clear()
	print("inventory cleared.")
