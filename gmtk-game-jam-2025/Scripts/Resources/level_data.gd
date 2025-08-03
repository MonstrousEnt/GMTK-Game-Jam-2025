@tool
class_name LevelData
extends Resource


## Emitted when value of level unlocked is changed
signal level_unlocked_changed
## Emitted when value of level completed is changed
signal level_completed_changed
## Emitted when value room of room data is changed
signal room_data_changed


## Path to level scene
@export_file("*.tscn") var level_scene_path: String

## Whether this level is unlocked
@export var unlocked: bool = false: 
	set(value):
		if value != unlocked:
			unlocked = value
			level_unlocked_changed.emit()

## Whether this level is completed
@export var completed: bool = false:
	set(value):
		if value != completed:
			completed = value
			level_completed_changed.emit()

## Data for rooms in this level
@export var room_data: Array[RoomData]:
	set(value):
		room_data = value
		room_data_changed.emit()
