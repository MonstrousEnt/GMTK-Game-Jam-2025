class_name OptionsMenu
extends MenuState


@export var back_menu: MenuState


@onready var back_button: Button = %BackButton

@onready var master_slider: Slider = %MasterVolumeSlider
@onready var music_slider: Slider = %MusicVolumeSlider
@onready var sound_slider: Slider = %SoundEffectsVolumeSlider


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
	master_slider.value_changed.connect(_on_master_changed)
	music_slider.value_changed.connect(_on_music_changed)
	sound_slider.value_changed.connect(_on_sound_changed)


func _disconnect_signals() -> void:
	back_button.pressed.disconnect(_on_back_pressed)
	master_slider.value_changed.disconnect(_on_master_changed)
	music_slider.value_changed.disconnect(_on_music_changed)
	sound_slider.value_changed.disconnect(_on_sound_changed)


func _on_back_pressed() -> void:
	Transitioned.emit(self, back_menu)


func _on_master_changed() -> void:
	pass


func _on_music_changed() -> void:
	pass


func _on_sound_changed() -> void:
	pass
