"""
	Project Name: Edge of Origin
	Team Name: Edge of Origin Team
	Authors: Daniel, Max
	Created Date: July 30, 2025
	Last Updated: August 3, 2025
	Description: This is class for level button
	Notes: 
	Resources:
"""

class_name LevelButton extends Button

##
## SETTERS AND GETTERS
##

var force_disabled: bool = false:
	set(value):
		force_disabled = value

		if level_data:
			disabled = !level_data.unlocked || force_disabled
		else:
			disabled = force_disabled

var level_data: LevelData:
	set(value):
		if value == null:
			_disconnect_level_data_signals()

		level_data = value

		if level_data != null:
			_connect_level_data_signals()

		update_button()


##
## SIGNAL VARIABLES
##

## Emitted when the level button is pressed
signal level_pressed(level_data: LevelData)

##
## BUILT IN METHODS
##

func _ready() -> void:
	_connect_signals()
	update_button()


func _exit_tree() -> void:
	_disconnect_signals()

##
## CLASS METHODS
##

## Update button to display level data
func update_button() -> void:
	if level_data == null:
		self.text = "?"
		self.disabled = true
		return

	var level_number = GameManager.levels.find(level_data)

	if level_number <= -1:
		self.text = "?"
		self.disabled = true
		return

	self.text = str(level_number)
	self.disabled = !level_data.unlocked || force_disabled

##
## SIGNAL METHODS
##

func _connect_signals() -> void:
	self.pressed.connect(_on_pressed)
	_connect_level_data_signals()

func _disconnect_signals() -> void:
	self.pressed.disconnect(_on_pressed)
	_disconnect_level_data_signals()

## Handle button pressed
func _on_pressed() -> void:
	level_pressed.emit(level_data)

## Connect level data resource signals
func _connect_level_data_signals() -> void:
	if level_data == null:
		return

	if !level_data.level_unlocked_changed.is_connected(_on_level_unlocked_changed):
		level_data.level_unlocked_changed.connect(_on_level_unlocked_changed)

	if !level_data.level_completed_changed.is_connected(_on_level_completed_changed):
		level_data.level_completed_changed.connect(_on_level_completed_changed)

## Disconnect level data resource signals
func _disconnect_level_data_signals() -> void:
	if level_data == null:
		return

	if level_data.level_unlocked_changed.is_connected(_on_level_unlocked_changed):
		level_data.level_unlocked_changed.disconnect(_on_level_unlocked_changed)

	if level_data.level_completed_changed.is_connected(_on_level_completed_changed):
		level_data.level_completed_changed.disconnect(_on_level_completed_changed)

## Handle level unlocked value changed
func _on_level_unlocked_changed() -> void:
	update_button()

## Handle level completed value changed
func _on_level_completed_changed() -> void:
	update_button()
