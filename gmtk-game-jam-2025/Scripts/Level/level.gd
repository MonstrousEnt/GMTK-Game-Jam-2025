"""
	Project Name: Edge of Origin
	Team Name: Edge of Origin Team
	Authors: Daniel, Max
	Created Date: July 30, 2025
	Last Updated: August 3, 2025
	Description: This is the class for game levels.
	Notes: 
	Resources:
"""

@tool
class_name Level extends Node2D

##
## CLASS VARIABLES
##

## Data for this level
@export var level_data: LevelData

## Room that the level starts with
@export var starting_room: Room

## Spawn point that the level starts with (Must be in starting room)
@export var starting_spawn_point: SpawnPoint

##
## SETTERS AND GETTERS
##

## All rooms in the level.
@export var rooms: Array[Room]:
	set(value):
		_disconnect_room_signals()
		rooms = value
		_connect_room_signals()

## Room the player is currently in
var current_room: Room:
	set(value):
		current_room = value

##
## BUILT IN METHODS
##

func _ready() -> void:
	update_level_data_room_data()
	_connect_room_signals()

func _exit_tree() -> void:
	_disconnect_room_signals()

##
## CLASS METHODS
##

## Update list of room data in level data
func update_level_data_room_data() -> void:
	if level_data.room_data == null:
		level_data.room_data = []

	for room in rooms:
		if room.room_data == null:
			continue

		if level_data.room_data.has(room.room_data):
			continue

		level_data.room_data.append(room.room_data)

## Set all rooms accept current room to not visible
func update_rooms_visibility() -> void:
	if rooms == null:
		return

	for room in rooms:
		room.visible = room == current_room

##
## SIGNAL METHODS
##

## Connect to all room data signals
func _connect_room_signals() -> void:
	for room in rooms:
		if room.get("room_data") != null:
			if !room.room_data_changed.is_connected(_on_room_data_changed):
				room.room_data_changed.connect(_on_room_data_changed)

## Disconnect from all room data signals
func _disconnect_room_signals() -> void:
	for room in rooms:
		if room.get("room_data") != null:
			if room.room_data_changed.is_connected(_on_room_data_changed):
				room.room_data_changed.disconnect(_on_room_data_changed)

## Handle room data changed in room
func _on_room_data_changed() -> void:
	_disconnect_room_signals()
	update_level_data_room_data()
	_connect_room_signals()
