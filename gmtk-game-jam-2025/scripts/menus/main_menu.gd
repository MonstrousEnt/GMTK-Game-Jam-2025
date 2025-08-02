class_name MainMenu
extends MenuState


@export var level_menu: MenuState


@onready var play_button: Button = %PlayButton
@onready var quit_button: Button = %QuitButton


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
	play_button.pressed.connect(_on_play_pressed)
	quit_button.pressed.connect(_on_quit_pressed)


func _disconnect_signals() -> void:
	play_button.pressed.disconnect(_on_play_pressed)
	quit_button.pressed.disconnect(_on_quit_pressed)


func _on_play_pressed() -> void:
	Transitioned.emit(self, level_menu)


func _on_quit_pressed() -> void:
	get_tree().quit()
