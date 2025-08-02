extends Node
class_name State

signal Transitioned(state, new_state)

var active := false:
	set(value):
		active = value
		_on_active_value_changed()


func enter() -> void:
	active = true
	pass


func exit() -> void:
	active = false
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func input(_event: InputEvent) -> void:
	pass


func unhandled_input(_event: InputEvent) -> void:
	pass


func _on_active_value_changed() -> void:
	pass
