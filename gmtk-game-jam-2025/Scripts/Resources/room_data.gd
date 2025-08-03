"""
	Project Name: Edge of Origin
	Team Name: Edge of Origin Team
	Authors: Daniel, Max
	Created Date: July 30, 2025
	Last Updated: August 3, 2025
	Description: Data for a room in a level
	Notes: 
	Resources:
"""

@tool
class_name RoomData extends Resource

##
## SETTERS AND GETTERS
##

## Position of room on 3D map
@export var room_position: Vector3 = Vector3.ZERO:
	set(value):
		room_position = value
		room_data_changed.emit()

## Rotation of room on 3D map
@export var room_rotation: Vector3 = Vector3.ZERO:
	set(value):
		room_rotation = value
		room_data_changed.emit()


## Size of the room plane mesh on 3D map
@export var room_size: Vector2 = Vector2(1, 1):
	set(value):
		room_size = value
		room_data_changed.emit()


##
## SIGNAL VARIABLES
##

## Emitted when room position, rotation, or size values are changed
signal room_data_changed
