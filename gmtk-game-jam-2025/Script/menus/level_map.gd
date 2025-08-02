@tool
class_name LevelMap
extends Node3D


@export var level_data: LevelData:
	set(value):
		_disconnect_room_data_signals()
		_disconnect_level_data_signals()
		level_data = value
		_connect_room_data_signals()
		_connect_level_data_signals()

## Material applied to room meshes
@export var room_material: Material

@export_tool_button("Build Level Map", "Callable") var build_map_action = _on_build_map_pressed


var room_meshes: Dictionary[StringName, MeshInstance3D] = {}
## Axis aligned bounding box of all room meshes combined
var meshes_aabb: AABB


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
## METHODS
##


## Create mesh for map from level data
func build_map_mesh() -> void:
	if level_data == null:
		for mesh in room_meshes.values():
			mesh.free()

		room_meshes = {}
		return

	for room_data in level_data.room_data:
		if room_meshes.has(room_data.resource_path):
			room_meshes[room_data.resource_path].mesh.size = room_data.room_size
			room_meshes[room_data.resource_path].position = room_data.room_position
			room_meshes[room_data.resource_path].rotation_degrees = room_data.room_rotation
		else:
			var mesh = create_room_mesh(room_data)
			room_meshes[room_data.resource_path] = mesh
			self.add_child(mesh)


## Create a mesh instance from room data
func create_room_mesh(room_data: RoomData) -> MeshInstance3D:
	# Create plane mesh
	var mesh = PlaneMesh.new()
	mesh.size = room_data.room_size
	mesh.material = room_material.duplicate(true)

	# Create mesh instance
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.position = room_data.room_position
	mesh_instance.rotation_degrees = room_data.room_rotation

	# Set mesh instance mesh
	mesh_instance.mesh = mesh

	return mesh_instance


# Remove any mesh instances for rooms that are not in level data
func clean_map_mesh() -> void:
	for key in room_meshes.keys():
		if !level_data.room_data.find_custom(func(room_data): return room_data.resource_path == key):
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




## Connect level data signals
func _connect_level_data_signals() -> void:
	if level_data == null:
		return

	if !level_data.room_data_changed.is_connected(_on_level_room_data_changed):
		level_data.room_data_changed.connect(_on_level_room_data_changed)


## Disconnect level data signals
func _disconnect_level_data_signals() -> void:
	if level_data == null:
		return

	if level_data.room_data_changed.is_connected(_on_level_room_data_changed):
		level_data.room_data_changed.disconnect(_on_level_room_data_changed)
	

## Connect to all level room data signals
func _connect_room_data_signals() -> void:
	if level_data == null || level_data.room_data == null:
		return

	for room_data in level_data.room_data:
		if !room_data.room_data_changed.is_connected(_on_room_data_changed):
			room_data.room_data_changed.connect(_on_room_data_changed)


## Disconnect to all room data signals
func _disconnect_room_data_signals() -> void:
	if level_data == null || level_data.room_data == null:
		return

	for room_data in level_data.room_data:
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
