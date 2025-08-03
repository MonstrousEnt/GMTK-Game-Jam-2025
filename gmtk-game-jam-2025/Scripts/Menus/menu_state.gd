"""
	Project Name: Edge of Origin
	Team Name: Edge of Origin Team
	Authors: Daniel, Max
	Created Date: July 30, 2025
	Last Updated: August 3, 2025
	Description: This is class for the state for the menus.
	Notes: 
	Resources:
"""

class_name MenuState extends State

##
## CLASS VARIABLES
##

## Control element to focus when entering this map state
@export var enter_focus: Control

##
## BUILT IN METHODS
##

func _ready() -> void:
	self.visible = active

func enter() -> void:
	super()
	if enter_focus is Control:
		enter_focus.grab_focus()


##
## SIGNAL METHODS
##

func _on_active_value_changed() -> void:
	super()
	self.visible = active
