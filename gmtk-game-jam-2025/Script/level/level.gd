@tool
class_name Level
extends Node2D
## A game level

## Data for this level
@export var level_data: LevelData

## All rooms in the level.
@export var rooms: Array[Room]:
	set(value):
		_disconnect_room_signals()
		rooms = value
		_connect_room_signals()

## Room that the level starts with
@export var starting_room: Room


##
## BUILT IN METHDOS
##


func _ready() -> void:
	update_level_data_room_data()
	_connect_room_signals()


func _exit_tree() -> void:
	_disconnect_room_signals()


##
## METHODS
##


## Update list of room data in level data
func update_level_data_room_data() -> void:
	var room_data: Array = rooms.map(func(room: Room): return room.room_data)
	level_data.room_data = room_data.filter(func(data): return data is RoomData)


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
