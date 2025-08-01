class_name LevelData
extends Resource


## Emitted when value of level unlocked is changed
signal level_unlocked_changed


## Path to level scene
@export_file("*.tscn") var level_scene_path: String

## Whether this level is unlocked
@export var unlocked: bool = false: 
	set(value):
		if value != unlocked:
			unlocked = value
			level_unlocked_changed.emit()

## Whether this level is completed
@export var completed: bool = false
