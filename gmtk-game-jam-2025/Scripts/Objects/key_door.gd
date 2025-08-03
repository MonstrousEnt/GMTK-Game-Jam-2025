"""
	Project Name: Edge of Origin
	Team Name: Edge of Origin Team
	Authors: Daniel, Kyle
	Created Date: August 2, 2023
	Last Updated: August 3, 2023
	Description: This class is for door that need a key to enter
	Notes: 
	Resources:
"""

class_name KeyDoor extends Area2D

##
## CLASS VARIABLES
##

#Door 
@export var door_number: int = 0

##
## BUILT IN METHODS
##

# Check if the inventory has a key associated with this door.
func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		var has_correct_key = false
		
		var items = InventoryManager.get_items()
		print(items[0].item_name)
		
		for item in items:
			if (item is key and item.door_number == door_number):
				has_correct_key = true
				print("has the key and at the door.")
				
				if (has_correct_key):
					InventoryManager.remove_item(item.item_id)
					print("Door unlocked!")
					queue_free()
					break
				
