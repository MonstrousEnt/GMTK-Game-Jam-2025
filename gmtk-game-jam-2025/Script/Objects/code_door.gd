"""
	Project Name: Non Euclidean Puzzle Platformer
	Team Name: Vextor Games
	Authors: Daniel, Kyle
	Created Date: August 2, 2023
	Last Updated: August 3, 2023
	Description: This class is for door that need a code to enter
	Notes: 
	Resoucres:
"""

class_name CodeDoor extends Area2D

##
## Class Variables
##

#Code 
@export var code_to_unlock: int = 1234
var code_index: int = 0
var correct_code: Array = ["1", "2", "3", "4"]

#Player
var player_in_area: bool = false

##
## BUILT IN METHODS
##

# Check if player is within range of the door.
func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		player_in_area = true
		print("Player is at the door.")

# Check if player has exited range of the door.
func _on_body_exited(body: Node2D) -> void:
	if (body is Player):
		player_in_area = false
		code_index = 0
		print("Player left the door area.")

func _unhandled_input(event: InputEvent) -> void:
	if (player_in_area and event is InputEventKey and event.is_pressed()):
		# Boundary check for more than 4 presses.
		if (code_index >= correct_code.size()):
			return
			
		var keycode = event.as_text_keycode()

		# Check if the pressed key matches the next key
		if (keycode == correct_code[code_index]):
			code_index += 1
			print("Correct key pressed. Current index: ", code_index)
			
			# If the entire sequence has been entered, unlock the door
			if (code_index == correct_code.size()):
				print("Door unlocked.")
				queue_free()
		else:
			# If the wrong key is pressed, reset the sequence
			code_index = 0
			if keycode in correct_code:
				print("Incorrect key pressed, reset it")
				
