@tool
class_name RoomConnection
extends Area2D
## Connection point in a room to another room in the level
##
## Transitions the player to the target room connection when the player enters
## the room connections area


## Emitted when a player enters the room connections area
signal player_entered(room_connection: RoomConnection, player: Node2D)


## The room this room connection is in
@export var room: Room: 
	set(value):
		room = value

		if room is Room && room.room_connections.find(self) == -1:
			room.room_connections.append(self)

		update_configuration_warnings()

## The room connection this room connection targets
@export var target_connection: RoomConnection:
	set(value):
		target_connection = value
		queue_redraw()
		update_configuration_warnings()

## Rotation, in degrees, to apply when transitioning to target room connection
@export var connection_rotation: float = 0

## Offset from room connection position when player enters room at this room connection
@export var player_entrance_offset: Vector2 = Vector2.ZERO:
	set(value):
		player_entrance_offset = value
		queue_redraw()

## Draw debug visuals durring runtime
@export var debug_draw: bool = false


##
## BUILT IN METHODS
##


func _ready() -> void:
	_connect_signals()


func _process(_delta: float) -> void:
	if Engine.is_editor_hint() && target_connection != null:
		queue_redraw()


func _exit_tree() -> void:
	_disconnect_signals()


func _draw() -> void:
	if !Engine.is_editor_hint() && !debug_draw:
		return

	var color = Color.AQUAMARINE
	var arrow_color = Color.LIME_GREEN
	var arrow_width = 1
	var width = 1

	var radius = 16
	draw_line(player_entrance_offset + Vector2(0, radius), player_entrance_offset - Vector2(0, radius), color, width)
	draw_line(player_entrance_offset + Vector2(radius, 0), player_entrance_offset - Vector2(radius, 0), color, width)

	if !Engine.is_editor_hint():
		return

	if target_connection != null:
		var target_position_local = self.to_local(target_connection.global_position)
		var arrow_dir = Vector2.ZERO.direction_to(target_position_local)

		draw_line(Vector2.ZERO, target_position_local, arrow_color, arrow_width, true)
		draw_line(target_position_local, target_position_local - arrow_dir.rotated(PI / 4) * 16, arrow_color, arrow_width, true)
		draw_line(target_position_local, target_position_local - arrow_dir.rotated(-PI / 4) * 16, arrow_color, arrow_width, true)


func _get_configuration_warnings():
	var warnings = []

	if room == null:
		warnings.append("Connection is not assigned to a room")

	if target_connection == null:
		warnings.append("Connection is not targeting a room connection")

	return warnings


##
## METHODS
##


func _connect_signals() -> void:
	self.body_entered.connect(_on_body_entered)


func _disconnect_signals() -> void:
	self.body_entered.disconnect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	player_entered.emit(self, body)
