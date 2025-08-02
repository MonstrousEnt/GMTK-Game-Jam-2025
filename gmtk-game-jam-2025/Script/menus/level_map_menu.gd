@tool
class_name LevelMapMenu
extends Control


@onready var camera: Camera3D = %Camera3D
@onready var camera_pivot: Node3D = %CameraPivot
@onready var level_map: LevelMap = %LevelMap

@export_tool_button("Update Camera Size", "Callable") var update_action = update_camera_fit


##
## METHODS
##


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
