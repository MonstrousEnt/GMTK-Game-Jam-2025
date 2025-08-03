"""
	Project Name: Edge of Origin
	Team Name: Edge of Origin Team
	Authors: Kyle, Daniel
	Created Date: July 30, 2023
	Last Updated: August 3, 2023
	Description: This class is the controller for the player animations
	Notes: 
	Resources:
"""

class_name AnimationController extends AnimatedSprite2D

##
## METHODS
##

# Play's an animation based on it's name and prevents the animation
# from restarting every frame.
func play_animation(anim: String):
	if (animation != anim):
		play(anim)
