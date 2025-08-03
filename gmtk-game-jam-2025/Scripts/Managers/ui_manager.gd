class_name UIManagerSingleton
extends Control
## Singleton for managing game UI


## Whether the level map is currently being displayed
var showing_map: bool = false


@onready var loading_screen: Control = %LoadingScreen
@onready var loading_bar: ProgressBar = %LoadingProgressBar
@onready var menus: StateMachine = %Menus
@onready var pause_menus: StateMachine = %PauseMenus
@onready var level_map_menu: LevelMapMenu = %LevelMapMenu


##
## BUILT IN METHODS
##


func _ready() -> void:
	_set_loading_screen_visibility()
	_connect_signals()
	update_pause_menus()
	level_map_menu.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("game_pause"):
		if GameManager.in_level && get_tree().paused == false:
			pause_game()
			get_viewport().set_input_as_handled()

	if event.is_action_pressed("game_toggle_map"):
		if GameManager.in_level && get_tree().paused == false:
			show_level_map()
			get_viewport().set_input_as_handled()


func _exit_tree() -> void:
	_disconnect_signals()


##
## METHODS
##


## Pause the game and show the pause menu
func pause_game() -> void:
	if !GameManager.in_level:
		return

	if get_tree().paused:
		return

	if !pause_menus.started:
		pause_menus.start()

	get_tree().paused = true
	pause_menus.change_state(pause_menus.initial_state)
	update_pause_menus()


## Unpause the game and hide the pause menu
func unpause_game() -> void:
	get_tree().paused = false
	update_pause_menus()


## Show the level map and pause the game
func show_level_map() -> void:
	if !GameManager.in_level:
		return

	get_tree().paused = true
	showing_map = true
	level_map_menu.reset_camera_angle()
	level_map_menu.visible = true


## Hide the level map and unpause the game
func hide_level_map() -> void:
	unpause_game()
	showing_map = false
	level_map_menu.visible = false


## Sets the level map to the current level
func set_level_map_to_current() -> void:
	if !(LevelManager.current_level is Level):
		return

	level_map_menu.set_level_map_level(LevelManager.current_level)


## Update visibility of the pause menu
func update_pause_menus() -> void:
	pause_menus.visible = GameManager.in_level && get_tree().paused


func _connect_signals() -> void:
	GameManager.loading_changed.connect(_on_loading_changed)
	GameManager.loading_progress_changed.connect(_on_loading_progress_changed)
	GameManager.in_level_changed.connect(_on_in_level_changed)


func _disconnect_signals() -> void:
	GameManager.loading_changed.disconnect(_on_loading_changed)
	GameManager.in_level_changed.disconnect(_on_in_level_changed)


## Handle loading state changed
func _on_loading_changed() -> void:
	_set_loading_screen_visibility()


## Handle loading progress changed
func _on_loading_progress_changed(progress: float) -> void:
	loading_bar.value = progress * 100


## Set the visibility of the loading screen based on loading state
func _set_loading_screen_visibility() -> void:
	loading_screen.visible = GameManager.loading


## Handle in level state changed
func _on_in_level_changed() -> void:
	menus.visible = !GameManager.in_level

	if !GameManager.in_level:
		hide_level_map()
