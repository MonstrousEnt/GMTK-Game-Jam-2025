class_name UIManagerSingleton
extends Control
## Singleton for managing game UI


@onready var loading_screen: Control = %LoadingScreen
@onready var loading_bar: ProgressBar = %LoadingProgressBar
@onready var menus: Control = %Menus


##
## BUILT IN METHODS
##


func _ready() -> void:
	_set_loading_screen_visibility()
	_connect_signals()


func _exit_tree() -> void:
	_disconnect_signals()


##
## METHODS
##


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
