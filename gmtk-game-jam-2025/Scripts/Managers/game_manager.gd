"""
	Project Name: Edge of Origin
	Team Name: Edge of Origin Team
	Authors: Daniel, Max
	Created Date: July 30, 2025
	Last Updated: August 3, 2025
	Description: This is the game manager class.
	Notes: 
	Resources:
"""

class_name GameManagerSingleton extends Node

##
## CLASS VARIABLES
##

#Level
@export var levels: Array[LevelData]

#Audio
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer

##
## SETTERS AND GETTERS
##

## Whether the game is loading
var loading: bool = false:
	set(value):
		if value != loading:
			loading = value
			loading_changed.emit()

## The game is  in the level
var in_level: bool = false:
	set(value):
		if value != in_level:
			in_level = value
			in_level_changed.emit()

##
## SIGNAL VARIABLES
##

## Emitted when loading value changed
signal loading_changed

## Emitted when loading progress value changed
signal loading_progress_changed(progress: float)

## Emitted when in level value changed
signal in_level_changed

##
## BUILT IN METHODS
##

func _ready() -> void:
	_connect_signals()
	audio_stream_player.play()

func _exit_tree() -> void:
	_disconnect_signals()

##
## MANAGER METHODS
##

## Load and start a level
func play_level(level_data: LevelData) -> void:
	# Return if level is not unlocked
	if !level_data.unlocked:
		print("Not unlocked")
		return

	# Return if level manager is already loading a level
	if LevelManager.loading:
		print("Already loading")
		return


	# Start loading level
	loading = true
	LevelManager.request_load_level(level_data.level_scene_path)

## Quit and unload a level
func quit_level() -> void:
	if !in_level:
		return

	get_tree().paused = true

	in_level = false
	LevelManager.unload_level()

	if UIManager.menus.current_state.enter_focus is Control:
		UIManager.menus.current_state.enter_focus.grab_focus()

## Unlock the next level in the game if there is one
func unlock_next_level() -> void:
	# Return if no current level
	if LevelManager.current_level == null:
		return

	var current_level_idx = levels.find(LevelManager.current_level.level_data)

	# Return if current level isnt found
	if current_level_idx <= -1:
		return

	# Return if no next level to unlock
	if current_level_idx + 1 >= levels.size():
		return

	var new_level = levels[current_level_idx + 1]

	# Unlock next level
	new_level.unlocked = true

##
## SIGNAL METHODS
##

func _connect_signals() -> void:
	LevelManager.level_loaded.connect(_on_level_loaded)
	LevelManager.level_load_failed.connect(_on_level_load_failed)
	LevelManager.level_load_progress_changed.connect(_on_level_load_progress_changed)

func _disconnect_signals() -> void:
	LevelManager.level_loaded.disconnect(_on_level_loaded)
	LevelManager.level_load_failed.disconnect(_on_level_load_failed)
	LevelManager.level_load_progress_changed.disconnect(_on_level_load_progress_changed)

## Handle level loaded signal
func _on_level_loaded() -> void:
	loading = false
	in_level = true
	get_tree().paused = false
	UIManager.set_level_map_to_current()
	LevelManager.player_rotation = 0
	LevelManager.start_level()

## Handle level load failed signal
func _on_level_load_failed() -> void:
	print("Failed to load level")
	loading = false

## Handle level load progress changed signal
func _on_level_load_progress_changed() -> void:
	loading_progress_changed.emit(LevelManager.level_load_progress)
