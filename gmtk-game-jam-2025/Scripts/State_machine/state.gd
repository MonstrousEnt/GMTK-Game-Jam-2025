"""
	Project Name: Edge of Origin
	Team Name: Edge of Origin Team
	Authors: Daniel, Max
	Created Date: July 30, 2025
	Last Updated: August 3, 2025
	Description: A generic state to be used with a state machine
	Notes: 
	Resources:
"""

class_name State extends Node

##
## SETTERS AND GETTERS
##

var active := false:
	set(value):
		active = value
		_on_active_value_changed()

##
## SIGNAL VARIABLES
##

signal Transitioned(state, new_state)

##
## CLASS METHODS
##

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

##
## SIGNAL METHODS
##

## Handle active value changed
func _on_active_value_changed() -> void:
	pass
