extends Node2D

# Map action to list of physical inputs.
var input_map = {
	"move_left": [KEY_A, KEY_LEFT, "dpad_left"],
	"move_right": [KEY_D, KEY_RIGHT, "dpad_right"],
	# Commented out for now, until we actually have rotating camera.
	#"move_up": [KEY_W, KEY_UP, "dpad_up"],
	#"move_down": [KEY_S, KEY_DOWN, "dpad_down"],
	"jump": [KEY_SPACE, "A"]
}

#--- Handle if an action was just released ---
# Jump action still needs setup properly in Godot's project settings!.
func is_action_just_released(action_name: String) -> bool:
	if InputMap.has_action(action_name):
		if Input.is_action_just_released(action_name):
			return true
	return false

#--- Handle if action is currently being held down ---
func is_action_pressed(action_name: String) -> bool:
	if input_map.has(action_name):
		for input in input_map[action_name]:
			if input is int:
				if Input.is_key_pressed(input):
					return true
			elif input is String:
				var joy_button = _get_joy_button_from_string(input)
				if Input.is_joy_button_pressed(0, _get_joy_button_from_string(input)):
					return true
	return false

#--- Handle is action was just pressed this frame ---
func is_action_just_pressed(action_name: String) -> bool:
	if input_map.has(action_name):
		for input in input_map[action_name]:
			if input is int:
				if Input.is_key_pressed(input):
					return true
				elif input is String:
					var joy_button = _get_joy_button_from_string(input)
					if input.is_joy_button_pressed(0, _get_joy_button_from_string(input)):
						return true
	return false

#--- Convert's joypad button string to its integer value. ---
func _get_joy_button_from_string(button_string: String):
	match button_string:
		"A": return JOY_BUTTON_A
		"B": return JOY_BUTTON_B
		"X": return JOY_BUTTON_X
		"Y": return JOY_BUTTON_Y
		"dpad_left": return JOY_BUTTON_DPAD_LEFT
		"dpad_right": return JOY_BUTTON_DPAD_RIGHT
		"dpad_up": return JOY_BUTTON_DPAD_UP
		"dpad_down": return JOY_BUTTON_DPAD_DOWN
	# 
	return -1
