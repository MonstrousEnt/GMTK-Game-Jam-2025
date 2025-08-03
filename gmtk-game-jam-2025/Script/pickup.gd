extends Area2D

@export var item_data_resource: item_data

# Check if player has entered pickup range of an item.
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print("player is on item, so pick it up.")
		# Add the item to the inventory.
		InventoryManager.add_item(item_data_resource)
		queue_free()
