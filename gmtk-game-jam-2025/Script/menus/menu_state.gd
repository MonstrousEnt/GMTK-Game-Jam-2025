class_name MenuState
extends State


##
## BUILT IN METHODS
##


func _ready() -> void:
	self.visible = active


##
## METHODS
##


func _on_active_value_changed() -> void:
	super()
	self.visible = active
