class_name LevelManagerSingleton
extends Node
## Singleton for managing the state of levels


## Emitted when the value of level loading progress is changed
signal level_load_progress_changed
## Emitted when the level fails to load
signal level_load_failed
## Emitted when a level is loaded
signal level_loaded

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


## Start level gameplay
func start_level() -> void:
	print("TODO: start level logic")


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
