class_name MenuState
extends State


## Control element to focus when entering this map state
@export var enter_focus: Control


##
## BUILT IN METHODS
##


func _ready() -> void:
	self.visible = active


func enter() -> void:
	super()
	if enter_focus is Control:
		enter_focus.grab_focus()


##
## METHODS
##


func _on_active_value_changed() -> void:
	super()
	self.visible = active
