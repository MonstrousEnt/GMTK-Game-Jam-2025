class_name LevelManagerSingleton
extends Node
## Singleton for managing the state of levels


## Emitted when the value of level loading progress is changed
signal level_load_progress_changed
## Emitted when the level fails to load
signal level_load_failed
## Emitted when a level is loaded
signal level_loaded


## Player character
@export var player: Player

## Whether a level is loading
var loading: bool = false

## Path to loading level
var loading_level_path: String
## Status of level loading
var level_load_status: ResourceLoader.ThreadLoadStatus
## Progress of level loading (0-1)
var level_load_progress: float = 0

## Path to the current level
var current_level_path: String
## Current level node
var current_level: Level

## Current player rotation 
var player_rotation: float = 0


##
## BUILT IN METHODS
##


func _process(_delta: float) -> void:
	_update_level_loading_status()


##
## METHODS
##


## Start loading a level at a given path
func request_load_level(path: String) -> void:
	loading = true
	loading_level_path = path
	ResourceLoader.load_threaded_request(path)


## Unload the current level
func unload_level() -> void:
	if current_level == null:
		return

	current_level.queue_free()
	current_level_path = ""


## Start level gameplay
func start_level() -> void:
	if current_level == null:
		return

	# Set current room to level starting room
	current_level.current_room = current_level.starting_room
	current_level.current_room.active = true
	current_level.update_rooms_visibility()

	# Move player to starting spawn point
	player.global_position = current_level.starting_spawn_point.global_position

	# Update player camera
	update_player_camera_limits()
	player.player_camera.reset_smoothing()
	player.player_camera.make_current()

	# Make player active
	player.is_active = true


func change_room(room_connection: RoomConnection) -> void:
	if room_connection.room == null:
		return

	var new_room = room_connection.target_connection.room
	var target_connection = room_connection.target_connection

	# Deactivate player
	player.is_active = false

	# Update player rotation
	player_rotation += room_connection.connection_rotation

	# Set room rotation and position
	new_room.rotation_degrees = player_rotation

	# Move player to target room entrance
	player.global_position = target_connection.to_global(target_connection.player_entrance_offset)

	# Update current room
	current_level.current_room.active = false
	current_level.current_room = new_room
	current_level.current_room.active = true
	update_player_camera_limits()
	player.player_camera.reset_smoothing()

	# Set room visibilities
	current_level.update_rooms_visibility()

	# Reactivate player
	player.is_active = true


## Update the player cameras limits to be inside the current room
func update_player_camera_limits() -> void:
	if current_level == null || current_level.current_room == null || current_level.current_room.tilemap == null:
		player.player_camera.limit_top = -10000000
		player.player_camera.limit_left = -10000000
		player.player_camera.limit_bottom = 10000000
		player.player_camera.limit_right = 10000000

		return

	# TODO: Fix camera limits to work with level rotation

	# var tile_size = current_level.current_room.tilemap.tile_set.tile_size
	# var room_rect = current_level.current_room.tilemap.get_used_rect()
	# var room_offset = current_level.current_room.global_position
	#
	# player.player_camera.limit_top = room_rect.position.y * tile_size.y + room_offset.y
	# player.player_camera.limit_left = room_rect.position.x * tile_size.x + room_offset.x
	# player.player_camera.limit_bottom = room_rect.end.y * tile_size.y + room_offset.y
	# player.player_camera.limit_right = room_rect.end.x * tile_size.x + room_offset.x
	#
	# var viewport_rect := get_viewport().get_visible_rect()
	#
	# if room_rect.size.x * tile_size.x < viewport_rect.size.x:
	# 	var size_diff := viewport_rect.size.x - float(room_rect.size.x * tile_size.x)
	#
	# 	player.player_camera.limit_left -= int(ceil(size_diff / 2))
	# 	player.player_camera.limit_right += int(ceil(size_diff / 2))
	#
	# if room_rect.size.y * tile_size.y < viewport_rect.size.y:
	# 	var size_diff := viewport_rect.size.y - float(room_rect.size.y * tile_size.y)
	#
	# 	player.player_camera.limit_top -= int(ceil(size_diff / 2))
	# 	player.player_camera.limit_bottom += int(ceil(size_diff / 2))


## Update the status of level loading
func _update_level_loading_status() -> void:
	if !loading:
		return

	var progress = []
	var status = ResourceLoader.load_threaded_get_status(loading_level_path, progress)

	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
		# Update load progress
		level_load_progress = progress[0]
		level_load_progress_changed.emit()
	
	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		# Update load progress
		level_load_progress = 1
		level_load_progress_changed.emit()

		# Remove old level
		if current_level != null: 
			current_level.free()

		# Add loaded level
		var loaded_level_resource = ResourceLoader.load_threaded_get(loading_level_path)
		current_level = loaded_level_resource.instantiate()
		current_level_path = loading_level_path
		add_child(current_level)

		# Stop loading
		loading = false
		level_loaded.emit()
	
	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED || status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_INVALID_RESOURCE:
		loading = false
		level_load_failed.emit()
