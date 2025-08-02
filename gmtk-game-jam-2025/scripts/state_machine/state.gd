extends Node
class_name State
## A generic state to be used with a state machine

signal Transitioned(state, new_state)

var active := false:
	set(value):
		active = value
		_on_active_value_changed()


## Called when state first becomes active
func enter() -> void:
	active = true
	pass


## Called when state becomes unactive
func exit() -> void:
	active = false
	pass


## Called every process frame while state is active
func update(_delta: float) -> void:
	pass


## Called every physics frame while state is active
func physics_update(_delta: float) -> void:
	pass


## Called for every input event while state is active
func input(_event: InputEvent) -> void:
	pass


## Called for every unhandled input event while state is active
func unhandled_input(_event: InputEvent) -> void:
	pass


## Handle active value changed
func _on_active_value_changed() -> void:
	pass
