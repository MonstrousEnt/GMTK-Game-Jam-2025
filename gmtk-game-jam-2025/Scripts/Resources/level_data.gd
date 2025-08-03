"""
	Project Name: Edge of Origin
	Team Name: Edge of Origin Team
	Authors: Daniel, Max
	Created Date: July 30, 2025
	Last Updated: August 3, 2025
	Description: This is the data class for level.
	Notes: 
	Resources:
"""

@tool
class_name LevelData extends Resource

##
## CLASS VARIABLES
##

## Path to level scene
@export_file("*.tscn") var level_scene_path: String

##
## SETTERS AND GETTERS
##

## Whether this level is unlocked
@export var unlocked: bool = false: 
	set(value):
		if value != unlocked:
			unlocked = value
			level_unlocked_changed.emit()

## Whether this level is completed
@export var completed: bool = false:
	set(value):
		if value != completed:
			completed = value
			level_completed_changed.emit()

## Data for rooms in this level
@export var room_data: Array[RoomData]:
	set(value):
		room_data = value
		room_data_changed.emit()

##
## SIGNAL VARIABLES
##

## Emitted when value of level unlocked is changed
signal level_unlocked_changed

## Emitted when value of level completed is changed
signal level_completed_changed

## Emitted when value room of room data is changed
signal room_data_changed