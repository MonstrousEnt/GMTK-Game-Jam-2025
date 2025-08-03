"""
	Project Name: Non Euclidean Puzzle Platformer
	Team Name: Vextor Games
	Authors: Daniel, Kyle
	Created Date: August 2, 2023
	Last Updated: August 3, 2023
	Description: This class any hazards in the game
	Notes: 
	Resoucres:
"""

class_name Hazard extends Area2D

##
## BUILT IN METHODS
##

# Any object of this class kills the player when they enter the radius.
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		$AudioStreamPlayer2D.play()
		body.queue_free()
		#TODO: Trigger game over screen or whatever.
