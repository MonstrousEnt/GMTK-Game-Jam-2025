"""
	Project Name: Edge of Origin
	Team Name: Edge of Origin Team
	Authors: Daniel, Max
	Created Date: July 30, 2025
	Last Updated: August 3, 2025
	Description: This is the class for the pause menu.
	Notes: 
	Resources:
"""

class_name PauseMenu extends MenuState

##
## CLASS VARIABLES
##

@export var options_menu: MenuState

@onready var resume_button: Button = %ResumeButton
@onready var options_button: Button = %OptionsButton
@onready var quit_level_button: Button = %QuitLevelButton


##
## BUILT IN METHODS
##

func _ready() -> void:
	super()
	_connect_signals()

func unhandled_input(event: InputEvent) -> void:
	super(event)

	if event.is_action_pressed("game_pause"):
		print("unpause")
		get_viewport().set_input_as_handled()
		_on_resume_pressed()

func _exit_tree() -> void:
	_disconnect_signals()

##
## SIGNAL METHODS
##

func _connect_signals() -> void:
	resume_button.pressed.connect(_on_resume_pressed)
	options_button.pressed.connect(_on_options_pressed)
	quit_level_button.pressed.connect(_on_quit_pressed)

func _disconnect_signals() -> void:
	resume_button.pressed.disconnect(_on_resume_pressed)
	options_button.pressed.disconnect(_on_options_pressed)
	quit_level_button.pressed.disconnect(_on_quit_pressed)

## Handle resume button pressed
func _on_resume_pressed() -> void:
	UIManager.unpause_game()

## Handle options button pressed
func _on_options_pressed() -> void:
	Transitioned.emit(self, options_menu)

## Handle quit level button pressed
func _on_quit_pressed() -> void:
	GameManager.quit_level()
	UIManager.update_pause_menus()
