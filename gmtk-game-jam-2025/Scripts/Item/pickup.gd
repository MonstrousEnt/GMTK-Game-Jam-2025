"""
	Project Name: Edge of Origin
	Team Name: Edge of Origin Team
	Authors: Daniel, Kyle
	Created Date: August 2, 2025
	Last Updated: August 3, 2025
	Description: This is class for pickup items.
	Notes: 
	Resources:
"""

class_name Pickup extends Area2D

##
## CLASS VARIABLES
##

#Item
@export var item_data_resource: item_data

##
## BUILT IN METHODS
##

# Check if player has entered pickup range of an item.
func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		print("player is on item, so pick it up.")

		# Add the item to the inventory.
		InventoryManager.add_item(item_data_resource)
		
		# Destroy the item game object.
		queue_free()
