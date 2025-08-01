class_name GameManagerSingleton
extends Node


@export var levels: Array[LevelData]


##
## BUILT IN METHODS
##


func _ready() -> void:
	_connect_signals()
	# TEMP: Load first level on game ready
	LevelManager.request_load_level("res://scenes/levels/level_0.tscn")
	await LevelManager.level_loaded


func _exit_tree() -> void:
	_disconnect_signals()


##
## METHODS
##


## Load and start a level
func play_level(level_data: LevelData) -> void:
	# Return if level is not unlocked
	if !level_data.unlocked:
		return

	# Return if level manager is already loading a level
	if LevelManager.loading:
		return

	# TODO: Show loading screen UI

	# Start loading level
	LevelManager.request_load_level(level_data.level_scene_path)


## Unlock the next level in the game if there is one
func unlock_next_level() -> void:
	# Return if no current level
	if LevelManager.current_level == null:
		return

	var current_level_idx = levels.find(LevelManager.current_level_path)

	# Return if current level isnt found
	if current_level_idx <= -1:
		return

	# Return if no next level to unlock
	if current_level_idx + 1 >= levels.size():
		return

	# Unlock next level
	levels[current_level_idx + 1].unlocked = true


func _connect_signals() -> void:
	LevelManager.level_loaded.connect(_on_level_loaded)
	LevelManager.level_load_failed.connect(_on_level_load_failed)


func _disconnect_signals() -> void:
	LevelManager.level_loaded.disconnect(_on_level_loaded)
	LevelManager.level_load_failed.disconnect(_on_level_load_failed)


func _on_level_loaded() -> void:
	LevelManager.start_level()


func _on_level_load_failed() -> void:
	print("Failed to load level")


