extends CharacterBody2D
@export var speed = 450
@export var jumpForce = 450
@export var gravity = 980
@export var acceleration = 600
@export var deceleration = 2400
@export var coyote_time = 0.1
@export var jump_buffer_time = 0.1
@export var jump_cut_gravity_multiplier = 2.0
@export var air_acceleration = 600 # For air control
@export var air_deceleration = 2400 # For air control

var camera_rotation_state = 0
var coyote_timer = 0.0
var jump_buffer_timer = 0.0

func _physics_process(delta):
	# --- GRAVITY AND TIMERS ---
	if not is_on_floor():
		velocity.y += gravity * delta
		coyote_timer -= delta
	else:
		coyote_timer = coyote_time

	# Cut the jump short if button is released and character is still rising.
	if Input.is_action_just_released("ui_up") and velocity.y < 0:
		velocity.y = velocity.y / jump_cut_gravity_multiplier

	# --- HORIZONTAL MOVEMENT ---
	var input_x = 0
	match camera_rotation_state:
		0: input_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		1: input_x = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		2: input_x = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
		3: input_x = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
	
	var target_speed = input_x * speed
	
	# Accelerate and decelerate the character's velocity based on input direction.
	if is_on_floor():
		if input_x != 0:
			velocity.x = move_toward(velocity.x, target_speed, acceleration * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, deceleration * delta)
	else: 
		if input_x != 0:
			velocity.x = move_toward(velocity.x, target_speed, air_acceleration * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, air_deceleration * delta)

	# --- JUMP BUFFER ---
	if Input.is_action_just_pressed("ui_up"):
		# If the jump was just pressed, buffer the command.
		jump_buffer_timer = jump_buffer_time
	else:
		# Start the timer to countdown every frame jump was not pressed.
		jump_buffer_timer -= delta
	
	# --- EXECUTE JUMP ---
	# Coyote time is used here so if a jump is executed just before landing
	# we accept the jump. More forgiving that way.
	if (coyote_timer > 0 or is_on_floor()) and jump_buffer_timer > 0:
		velocity.y = -jumpForce
		# Reset the timers to prevent double jumps.
		coyote_timer = 0
		jump_buffer_timer = 0
		# TODO: Add sound here!
	
	move_and_slide()
