class_name UIManagerSingleton
extends Control
## Singleton for managing game UI


@onready var loading_screen: Control = %LoadingScreen
@onready var loading_bar: ProgressBar = %LoadingProgressBar
@onready var menus: StateMachine = %Menus
@onready var pause_menus: StateMachine = %PauseMenus


##
## BUILT IN METHODS
##


func _ready() -> void:
	_set_loading_screen_visibility()
	_connect_signals()
	update_pause_menus()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("game_pause"):
		if GameManager.in_level && get_tree().paused == false:
			print("pause")
			pause_game()
			get_viewport().set_input_as_handled()

func _exit_tree() -> void:
	_disconnect_signals()


##
## METHODS
##


func pause_game() -> void:
	if !GameManager.in_level:
		return

	if get_tree().paused:
		return

	get_tree().paused = true
	pause_menus.change_state(pause_menus.initial_state)
	update_pause_menus()


func unpause_game() -> void:
	get_tree().paused = false
	update_pause_menus()


func update_pause_menus() -> void:
	pause_menus.visible = GameManager.in_level && get_tree().paused


func _connect_signals() -> void:
	GameManager.loading_changed.connect(_on_loading_changed)
	GameManager.loading_progress_changed.connect(_on_loading_progress_changed)
	GameManager.in_level_changed.connect(_on_in_level_changed)


func _disconnect_signals() -> void:
	GameManager.loading_changed.disconnect(_on_loading_changed)
	GameManager.in_level_changed.disconnect(_on_in_level_changed)


func _on_loading_changed() -> void:
	_set_loading_screen_visibility()


func _on_loading_progress_changed(progress: float) -> void:
	loading_bar.value = progress * 100


func _set_loading_screen_visibility() -> void:
	loading_screen.visible = GameManager.loading


func _on_in_level_changed() -> void:
	menus.visible = !GameManager.in_level
