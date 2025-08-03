"""
	Project Name: Edge of Origin
	Team Name: Edge of Origin Team
	Authors: Daniel, Max
	Created Date: July 30, 2025
	Last Updated: August 3, 2025
	Description: This is the ui class for credits menu.
	Notes: 
	Resources:
"""

class_name CreditsMenu extends MenuState

##
## CLASS VARIABLES
##

# Menu
@export var back_menu: MenuState

# Button
@onready var back_button: Button = %BackButton


##
## BUILT IN METHODS
##

func _ready() -> void:
	super()
	_connect_signals()

func _exit_tree() -> void:
	_disconnect_signals()

##
## SIGNAL METHODS
##

func _connect_signals() -> void:
	back_button.pressed.connect(_on_back_pressed)


func _disconnect_signals() -> void:
	back_button.pressed.disconnect(_on_back_pressed)

## Handle back button pressed
func _on_back_pressed() -> void:
	Transitioned.emit(self, back_menu)

