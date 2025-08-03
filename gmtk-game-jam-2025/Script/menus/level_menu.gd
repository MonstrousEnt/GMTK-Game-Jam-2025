class_name LevelMenu
extends MenuState


@export var main_menu: MenuState
@export var level_button_scene: PackedScene


var level_buttons: Array[LevelButton] = []


@onready var main_menu_button: Button = %MainMenuButton
@onready var level_buttons_container: Container = %LevelButtonsContainer


##
## BUILT IN METHODS
##


func _ready() -> void:
	super()
	_connect_signals()
	_create_level_buttons()


func enter() -> void:
	super()
	if level_buttons.size() > 0:
		level_buttons[0].grab_focus()
		enter_focus = level_buttons[0]
	else:
		main_menu_button.grab_focus()
		enter_focus = main_menu_button


func _exit_tree() -> void:
	_disconnect_signals()


##
## METHODS
##


## Create buttons for all levels
func _create_level_buttons() -> void:
	for level in GameManager.levels:
		# Create button
		var button: LevelButton = level_button_scene.instantiate()
		level_buttons.append(button)
		level_buttons_container.add_child(button)

		# Set button properties
		button.level_data = level
		button.force_disabled = GameManager.in_level || GameManager.loading

		# Connect button signal
		button.level_pressed.connect(_on_level_pressed)


## Set force disabled value for all level buttons
func _set_level_button_force_disabled() -> void:
	for button in level_buttons:
		button.force_disabled = GameManager.in_level || GameManager.loading


func _connect_signals() -> void:
	GameManager.in_level_changed.connect(_set_level_button_force_disabled)
	GameManager.loading_changed.connect(_set_level_button_force_disabled)
	main_menu_button.pressed.connect(_on_main_menu_pressed)


func _disconnect_signals() -> void:
	GameManager.in_level_changed.disconnect(_set_level_button_force_disabled)
	GameManager.loading_changed.disconnect(_set_level_button_force_disabled)
	main_menu_button.pressed.disconnect(_on_main_menu_pressed)

	for button in level_buttons:
		if button.level_pressed.is_connected(_on_level_pressed):
			button.level_pressed.disconnect(_on_level_pressed)


## Handle main menu button pressed
func _on_main_menu_pressed() -> void:
	Transitioned.emit(self, main_menu)


## Handle level button pressed
func _on_level_pressed(level_data: LevelData):
	GameManager.play_level(level_data)

