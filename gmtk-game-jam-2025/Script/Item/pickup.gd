"""
	Project Name: Non Euclidean Puzzle Platformer
	Team Name: Vextor Games
	Authors: Daniel, Kyle
	Created Date: August 2, 2023
	Last Updated: August 3, 2023
	Description: This is class for pickup items
	Notes: 
	Resoucres:
"""

class_name Pickup extends Area2D

##
## Class Variables
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
		queue_free()
