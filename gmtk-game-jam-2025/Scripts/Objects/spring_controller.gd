"""
	Project Name: Edge of Origin
	Team Name: Edge of Origin Team
	Authors: Daniel, Kyle
	Created Date: August 2, 2023
	Last Updated: August 3, 2023
	Description: This class is for spring objects
	Notes: 
	Resources:
"""

class_name SpringController extends Area2D

##
## CLASS VARIABLES
##

#Spring
@export var spring_power: int = 800
@export var spring_duration: float = 0.5

##
## BUILT IN METHODS
##

#--- Function check's for collisions with player and applies spring effect. ---
func _on_body_entered(body) -> void:
	if (body is Player):
		body.player_anim_controller.stop()
		$AudioStreamPlayer2D.play()
		body.is_sprung = true
		body.spring_timer = spring_duration
		
		# Apply direction to the player's velocity based on spring power.
		body.velocity.x = -cos(rotation + PI/2.0) * spring_power
		body.velocity.y = -sin(rotation + PI/2.0) * spring_power
