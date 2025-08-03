class_name StateMachine
extends Node
# A generic state machine for handling states


signal state_changed


@export var initial_state: State
@export var auto_start: bool = false

var started: bool = false
var current_state: State
var states: Dictionary[String, State] = {}

#
# BUILT IN METHODS
#

func _ready():
	states = _init_child_states()
	if auto_start:
		start()


func _process(delta):
	if not current_state:
		return
	
	current_state.update(delta)


func _physics_process(delta):
	if not current_state:
		return
	
	current_state.physics_update(delta)


func _input(event):
	if not current_state:
		return
	
	current_state.input(event)


func _unhandled_input(event):
	if not current_state:
		return
	
	current_state.unhandled_input(event)

#
# METHODS
#


## Start the state machine and enter the first state
func start() -> void:
	change_state(initial_state)
	started = true


## Change the current state to a new state
func change_state(new_state: State) -> void:
	if current_state == new_state:
		return

	if current_state:
		current_state.exit()

	current_state = new_state
	current_state.enter()

	state_changed.emit()


## Get all child state nodes and connect transition signal
func _init_child_states() -> Dictionary[String, State]:
	var child_states: Dictionary[String, State] = {}
	
	for child in get_children():
		if child is State:
			child_states[child.name] = child
			child.Transitioned.connect(_on_child_transition)
	
	return child_states


## Handle transition between states
func _on_child_transition(state: State, new_state: State):
	if state != current_state:
		return
	
	if !states.has(new_state.name):
		return
	
	change_state(new_state)
