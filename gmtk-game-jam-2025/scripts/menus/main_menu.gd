class_name MainMenu
extends MenuState


@export var level_menu: MenuState
@export var options_menu: MenuState
@export var credits_menu: MenuState


@onready var play_button: Button = %PlayButton
@onready var options_button: Button = %OptionsButton
@onready var credits_button: Button = %CreditsButton
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
	options_button.pressed.connect(_on_options_pressed)
	credits_button.pressed.connect(_on_credits_pressed)
	quit_button.pressed.connect(_on_quit_pressed)


func _disconnect_signals() -> void:
	play_button.pressed.disconnect(_on_play_pressed)
	options_button.pressed.disconnect(_on_options_pressed)
	credits_button.pressed.disconnect(_on_credits_pressed)
	quit_button.pressed.disconnect(_on_quit_pressed)


## Handle play button pressed
func _on_play_pressed() -> void:
	Transitioned.emit(self, level_menu)


## Handle options button pressed
func _on_options_pressed() -> void:
	Transitioned.emit(self, options_menu)


## Handle options button pressed
func _on_credits_pressed() -> void:
	Transitioned.emit(self, credits_menu)


## Handle quit button pressed
func _on_quit_pressed() -> void:
	get_tree().quit()
