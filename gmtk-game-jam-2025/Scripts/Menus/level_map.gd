"""
	Project Name: Edge of Origin
	Team Name: Edge of Origin Team
	Authors: Daniel, Max
	Created Date: July 30, 2025
	Last Updated: August 3, 2025
	Description: This is class render the 3d level map.
	Notes: 
	Resources:
"""

@tool
class_name LevelMap extends Node3D

##
## CLASS VARIABLES
##

## Material applied to room meshes
@export var room_material: StandardMaterial3D

@export_tool_button("Build Level Map", "Callable") var build_map_action = _on_build_map_pressed

var room_meshes: Dictionary[StringName, MeshInstance3D] = {}

## Axis aligned bounding box of all room meshes combined
var meshes_aabb: AABB

##
## SETTERS AND GETTERS
##

@export var level: Level:
	set(value):
		_disconnect_room_data_signals()
		_disconnect_level_data_signals()
		level = value
		_connect_room_data_signals()
		_connect_level_data_signals()


##
## BUILT IN METHODS
##


func _ready() -> void:
	_connect_level_data_signals()
	_connect_room_data_signals()


func _exit_tree() -> void:
	_disconnect_room_data_signals()
	_disconnect_level_data_signals()

##
## CLASS METHODS
##

## Create mesh for map from level data
func build_map_mesh() -> void:
	if level == null || level.level_data == null:
		for mesh in room_meshes.values():
			mesh.free()

		room_meshes = {}
		return

	for room_data in level.level_data.room_data:
		if room_meshes.has(room_data.resource_path):
			room_meshes[room_data.resource_path].mesh.size = room_data.room_size
			room_meshes[room_data.resource_path].position = room_data.room_position
			room_meshes[room_data.resource_path].rotation_degrees = room_data.room_rotation
		else:
			var mesh = create_room_mesh(room_data)
			room_meshes[room_data.resource_path] = mesh

## Create a mesh instance from room data
func create_room_mesh(room_data: RoomData) -> MeshInstance3D:
	var mesh_instance := MeshInstance3D.new()
	self.add_child(mesh_instance)

	# Create plane mesh
	var mesh = PlaneMesh.new()
	mesh.size = room_data.room_size

	# Set mesh material
	var material: StandardMaterial3D = room_material.duplicate(true)
	var room_idx = level.rooms.find_custom(func(room: Room): return room.room_data == room_data)
	if room_idx > -1:
		material.albedo_texture = level.rooms[room_idx].viewport_texture
	mesh.material = material

	# Create mesh instance
	mesh_instance.position = room_data.room_position
	mesh_instance.rotation_degrees = room_data.room_rotation

	# Set mesh instance mesh
	mesh_instance.mesh = mesh

	return mesh_instance

# Remove any mesh instances for rooms that are not in level data
func clean_map_mesh() -> void:
	for key in room_meshes.keys():
		if level.level_data.room_data.find_custom(func(room_data): return room_data.resource_path == key) == -1:
			room_meshes[key].queue_free()

func update_map_aabb() -> void:
	if room_meshes == null || room_meshes.size() == 0:
		return

	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	for mesh_instance: MeshInstance3D in room_meshes.values():
		if mesh_instance.mesh == null:
			continue
			
		var mesh := mesh_instance.mesh

		for surface_index in mesh.get_surface_count():
			st.append_from(mesh, surface_index, mesh_instance.transform)


	var combined_mesh = st.commit()
	meshes_aabb = combined_mesh.get_aabb()

##
## SIGNAL METHODS
##

## Connect level data signals
func _connect_level_data_signals() -> void:
	if level == null || level.level_data == null:
		return

	if !level.level_data.room_data_changed.is_connected(_on_level_room_data_changed):
		level.level_data.room_data_changed.connect(_on_level_room_data_changed)

## Disconnect level data signals
func _disconnect_level_data_signals() -> void:
	if level == null || level.level_data == null:
		return

	if level.level_data.room_data_changed.is_connected(_on_level_room_data_changed):
		level.level_data.room_data_changed.disconnect(_on_level_room_data_changed)
	
## Connect to all level room data signals
func _connect_room_data_signals() -> void:
	if level == null || level.level_data == null || level.level_data.room_data == null:
		return

	for room_data in level.level_data.room_data:
		if !room_data.room_data_changed.is_connected(_on_room_data_changed):
			room_data.room_data_changed.connect(_on_room_data_changed)

## Disconnect to all room data signals
func _disconnect_room_data_signals() -> void:
	if level == null || level.level_data == null || level.level_data.room_data == null:
		return

	for room_data in level.level_data.room_data:
		if room_data.room_data_changed.is_connected(_on_room_data_changed):
			room_data.room_data_changed.disconnect(_on_room_data_changed)

## Handle level room data changed
func _on_level_room_data_changed() -> void:
	_disconnect_room_data_signals()
	_connect_room_data_signals()

	if Engine.is_editor_hint():
		build_map_mesh()
		clean_map_mesh()
		update_map_aabb()

## Handle room data change
func _on_room_data_changed() -> void:
	build_map_mesh()
	update_map_aabb()

## Handle build map button pressed
func _on_build_map_pressed() -> void:
	build_map_mesh()
	update_map_aabb()
