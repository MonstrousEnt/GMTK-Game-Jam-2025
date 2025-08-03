class_name key_door
extends Area2D

@export var door_number: int = 0

# Check if the inventory has a key associated with this door.
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var has_correct_key = false
		
		var items = InventoryManager.get_items()
		print(items[0].item_name)
		for item in items:
			if item is key and item.door_number == door_number:
				has_correct_key = true
				print("has the key and at the door.")
				if has_correct_key:
					InventoryManager.remove_item(item.item_id)
					print("Door unlocked!")
					queue_free()
					break
				
