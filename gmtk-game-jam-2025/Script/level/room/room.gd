@tool
class_name Room
extends Node2D
## A room in a level


## emitted if room data is changed
signal room_data_changed


## Whether this is the current active room in the level
var active: bool = false


## All room connections in this room
@export var room_connections: Array[RoomConnection]:
	set(value):
		room_connections = value
		_set_childrens_room()
		_disconnect_signals()
		_connect_signals()


@export var room_data: RoomData:
	set(value):
		room_data = value
		room_data_changed.emit()


##
## BUILT IN METHODS
##


func _ready() -> void:
	_set_childrens_room()
	_connect_signals()


func _exit_tree() -> void:
	_disconnect_signals()


##
## METHODS
##


## Pass refrence to self to all children that require it
func _set_childrens_room() -> void:
	for room_connection in room_connections:
		if room_connection is RoomConnection:
			room_connection.room = self


func _connect_signals() -> void:
	for room_connection in room_connections:
		if room_connection is RoomConnection:
			if !room_connection.player_entered.is_connected(_on_player_entered_connection):
				room_connection.player_entered.connect(_on_player_entered_connection)


func _disconnect_signals() -> void:
	for room_connection in room_connections:
		if room_connection is RoomConnection:
			if room_connection.player_entered.is_connected(_on_player_entered_connection):
				room_connection.player_entered.disconnect(_on_player_entered_connection)


## Handle a body entering a room connection area
func _on_player_entered_connection(_room_connection: RoomConnection, _player: Node2D) -> void:
	print("TODO: ROOM TRANSITIONS")
