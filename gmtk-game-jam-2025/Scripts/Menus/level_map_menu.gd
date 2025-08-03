@tool
class_name LevelMapMenu
extends Control


## Speed of map rotation with mouse
@export var mouse_rotation_speed: float = 1
## Speed of map rotation with controller
@export var controller_rotation_speed: float = 1


@onready var exit_button: Button = %ExitButton
@onready var camera: Camera3D = %Camera3D
@onready var camera_pivot: Node3D = %CameraPivot
@onready var level_map: LevelMap = %LevelMap


## Whether the map rotating button is currently pressed
var is_mouse_rotating: bool = false


@export_tool_button("Update Camera Size", "Callable") var update_action = update_camera_fit


##
## BUILT IN METHODS
##


func _ready() -> void:
	_connect_signals()


func _process(_delta: float) -> void:
	update_map_rotation()


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


func set_level_map_level(level: Level) -> void:
	level_map.level = level
	level_map.build_map_mesh()
	level_map.clean_map_mesh()
	level_map.update_map_aabb()
	update_camera_fit()


## Update camera size and position to fit level map mesh
func update_camera_fit() -> void:
	if level_map.level == null || level_map.level.level_data == null || level_map.level.level_data.room_data == null || level_map.level.level_data.room_data.size() == 0:
		camera.size = 1

	if level_map.room_meshes == null || level_map.room_meshes.size() == 0:
		level_map.build_map_mesh()
		level_map.update_map_aabb()

	if level_map.meshes_aabb == null:
		level_map.update_map_aabb()

	var map_aab = level_map.meshes_aabb

	camera.size = map_aab.position.distance_to(map_aab.end) + 0.25
	camera_pivot.position = map_aab.get_center()


## Set rotation of camera with rotational clamping
func set_camera_rotation(new_rotation: Vector3) -> void:
	camera_pivot.rotation = new_rotation
	camera_pivot.rotation_degrees.x = clamp(camera_pivot.rotation_degrees.x, -80, 80)


## Set camera rotation to starting angle
func reset_camera_angle() -> void:
	set_camera_rotation(Vector3(-PI/4, PI/4, 0))


func update_map_rotation() -> void:
	is_mouse_rotating = Input.is_action_pressed("game_rotate_map_pc")

	if !UIManager.showing_map:
		return

	if is_mouse_rotating:
		# Mouse rotation

		var rotation_delta = Input.get_last_mouse_velocity().normalized() * 0.1 * mouse_rotation_speed
		set_camera_rotation(camera_pivot.rotation - Vector3(rotation_delta.y, rotation_delta.x, 0))

	else:
		# Controller rotation

		var rotation_delta = Vector3.ZERO
		rotation_delta.x = -Input.get_axis("game_rotate_map_down", "game_rotate_map_up")
		rotation_delta.y = Input.get_axis("game_rotate_map_left", "game_rotate_map_right")

		set_camera_rotation(camera_pivot.rotation + rotation_delta.normalized() * 0.1 * controller_rotation_speed)


func _connect_signals() -> void:
	exit_button.pressed.connect(_on_exit_pressed)


func _disconnect_signals() -> void:
	exit_button.pressed.disconnect(_on_exit_pressed)


## Handle exit pressed
func _on_exit_pressed() -> void:
	if UIManager.showing_map:
		UIManager.hide_level_map()
