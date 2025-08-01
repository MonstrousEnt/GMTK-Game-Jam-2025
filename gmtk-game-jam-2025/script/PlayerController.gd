extends CharacterBody2D

@export var speed: float = 250
@export var jumpForce: float = 450
@export var gravity: float = 980
@export var acceleration: float = 600
@export var deceleration: float = 2400
@export var coyote_time: float = 0.1
@export var jump_buffer_time: float = 0.1
@export var jump_cut_gravity_multiplier: float = 2.0
@export var air_acceleration: float = 600 # For air control
@export var air_deceleration: float = 2400 # For air control

@onready var player_anim_controller = $"AnimatedSprite2D"
@onready var input_manager = $"InputManager"

var camera_rotation_state: int = 0
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0

func _physics_process(delta) -> void:
	apply_gravity(delta)
	move_player(delta)
	jump(delta)
	move_and_slide()

func apply_gravity(delta) -> void:
	# --- GRAVITY AND TIMERS ---
	if not is_on_floor():
		velocity.y += gravity * delta
		coyote_timer -= delta
	else:
		coyote_timer = coyote_time

func move_player(delta) -> void:
	# --- HORIZONTAL MOVEMENT ---
	var input_x = 0
	# Check the logical actions defined in your InputManager
	var move_left = input_manager.is_action_pressed("move_left")
	var move_right = input_manager.is_action_pressed("move_right")
	var move_up = input_manager.is_action_pressed("move_up")
	var move_down = input_manager.is_action_pressed("move_down")
	
	match camera_rotation_state:
		0: input_x = int(move_right) - int(move_left)
		1: input_x = int(move_down) - int(move_up)
		2: input_x = int(move_left) - int(move_right)
		3: input_x = int(move_up) - int(move_down)
		
	var target_speed = input_x * speed
	
	# Accelerate and decelerate the character's velocity based on input direction.
	if is_on_floor():
		if input_x != 0:
			velocity.x = move_toward(velocity.x, target_speed, acceleration * delta)
			player_anim_controller.play("walk")
		else:
			velocity.x = move_toward(velocity.x, 0, deceleration * delta)
			player_anim_controller.play("idle")
	else: 
		if input_x != 0:
			velocity.x = move_toward(velocity.x, target_speed, air_acceleration * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, air_deceleration * delta)

func jump(delta) -> void:
		# Cut the jump short if button is released and character is still rising.
	if input_manager.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = velocity.y / jump_cut_gravity_multiplier
		
		# --- JUMP BUFFER ---
	if Input.is_action_just_pressed("jump") and is_on_floor():
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
		player_anim_controller.play("jump")
		# Reset the timers to prevent double jumps.
		coyote_timer = 0
		jump_buffer_timer = 0
		# TODO: Add sound here!
