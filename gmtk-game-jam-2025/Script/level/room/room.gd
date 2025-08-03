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


@export var tilemap: TileMapLayer:
	set(value):
		tilemap = value
		update_configuration_warnings()


@export var room_data: RoomData:
	set(value):
		room_data = value
		room_data_changed.emit()


@export var viewport_texture: ViewportTexture


@onready var viewport: SubViewport = %SubViewport
@onready var map_camera: Camera2D = %MapCamera


##
## BUILT IN METHODS
##


func _ready() -> void:
	_set_childrens_room()
	_connect_signals()
	set_map_viewport()


func _exit_tree() -> void:
	_disconnect_signals()


func _get_configuration_warnings() -> PackedStringArray:
	if tilemap == null:
		return ["tilemap not selected for room"]

	return []


##
## METHODS
##


## Pass refrence to self to all children that require it
func _set_childrens_room() -> void:
	for room_connection in room_connections:
		if room_connection is RoomConnection:
			room_connection.room = self


## Set the size of the viewport and position of camera for map rendering
func set_map_viewport() -> void:
	if tilemap == null:
		return

	var tilemap_bounds := tilemap.get_used_rect()

	viewport.size = tilemap_bounds.size * tilemap.tile_set.tile_size
	map_camera.position = Vector2(tilemap_bounds.get_center() * tilemap.tile_set.tile_size) + Vector2(tilemap.tile_set.tile_size) / 2

	# Create copy of tilemap for map rendering
	viewport.add_child(tilemap.duplicate())



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
