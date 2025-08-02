@tool
class_name LevelMapMenu
extends Control


@onready var exit_button: Button = %ExitButton
@onready var camera: Camera3D = %Camera3D
@onready var camera_pivot: Node3D = %CameraPivot
@onready var level_map: LevelMap = %LevelMap


@export_tool_button("Update Camera Size", "Callable") var update_action = update_camera_fit


##
## BUILT IN METHODS
##


func _ready() -> void:
	_connect_signals()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("game_toggle_map") || event.is_action_pressed("game_pause"):
		if UIManager.showing_map:
			UIManager.hide_level_map()
			get_viewport().set_input_as_handled()


func _exit_tree() -> void:
	_disconnect_signals()


##
## METHODS
##


func set_level_map_data(level_data: LevelData) -> void:
	level_map.level_data = level_data
	level_map.build_map_mesh()
	level_map.clean_map_mesh()
	update_camera_fit()


## Update camera size and position to fit level map mesh
func update_camera_fit() -> void:
	if level_map.level_data == null || level_map.level_data.room_data == null || level_map.level_data.room_data.size() == 0:
		camera.size = 1

	if level_map.room_meshes == null || level_map.room_meshes.size() == 0:
		level_map.build_map_mesh()
		level_map.update_map_aabb()

	if level_map.meshes_aabb == null:
		level_map.update_map_aabb()

	var map_aab = level_map.meshes_aabb

	camera.size = map_aab.position.distance_to(map_aab.end) + 1
	camera_pivot.position = map_aab.get_center()


## Set rotation of camera with rotational clamping
func set_camera_rotation(new_rotation: Vector3) -> void:
	camera_pivot.rotation = new_rotation
	camera_pivot.rotation_degrees.x = clamp(camera_pivot.rotation_degrees.x, -80, 80)


## Set camera rotation to starting angle
func reset_camera_angle() -> void:
	set_camera_rotation(Vector3(-PI/4, PI/4, 0))


func _connect_signals() -> void:
	exit_button.pressed.connect(_on_exit_pressed)


func _disconnect_signals() -> void:
	exit_button.pressed.disconnect(_on_exit_pressed)


## Handle exit pressed
func _on_exit_pressed() -> void:
	if UIManager.showing_map:
		UIManager.hide_level_map()
