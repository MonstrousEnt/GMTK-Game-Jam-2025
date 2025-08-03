class_name CreditsMenu
extends MenuState


@export var back_menu: MenuState


@onready var back_button: Button = %BackButton


##
## BUILT IN METHODS
##


func _ready() -> void:
	super()
	_connect_signals()


func _exit_tree() -> void:
	_disconnect_signals()


##
## METHODS
##


func _connect_signals() -> void:
	back_button.pressed.connect(_on_back_pressed)


func _disconnect_signals() -> void:
	back_button.pressed.disconnect(_on_back_pressed)


## Handle back button pressed
func _on_back_pressed() -> void:
	Transitioned.emit(self, back_menu)

