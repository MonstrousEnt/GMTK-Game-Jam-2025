"""
	Project Name: Non Euclidean Puzzle Platformer
	Team Name: Vextor Games
	Authors: Daniel Cox
	Created Date: July 30, 2023
	Last Updated: August 3, 2023
	Description: This class is the controller for the player
	Notes: 
	Resoucres:
"""

class_name Player extends CharacterBody2D

##
## Class Variables
##

#Move
@export var speed: float = 350
@export var acceleration: float = 600
@export var deceleration: float = 3000
@export var air_acceleration: float = 600 # For air control
@export var air_deceleration: float = 1200 # For air control

#Jump
@export var jumpForce: float = 450
@export var coyote_time: float = 0.1
@export var jump_buffer_time: float = 0.1
@export var jump_cut_gravity_multiplier: float = 2.0

var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0

#Gravity
@export var gravity: float = 980

#Spring
var is_sprung: bool = false
var spring_timer: float = 0.0

# References
@onready var player_anim_controller = $"AnimatedSprite2D"
@onready var input_manager = $"InputManager"
@onready var item_manager = $"ItemManager"


##
## BUILT IN METHODS
##

func _physics_process(delta) -> void:
	apply_gravity(delta)
	jump(delta)
	
	#stop the player move when is sprung otherwise the player can move
	if (is_sprung):
		# If the player is sprung, start the timer.
		spring_timer -= delta
		if spring_timer <= 0:
			is_sprung = false
	if (not is_sprung):
		# If the spring is finished, the player can move.
		move_player(delta)
		
	move_and_slide()

##
## METHODS
##

# Apply the gravity to player
func apply_gravity(delta) -> void:
	# --- GRAVITY AND TIMERS ---
	if (not is_on_floor()):
		player_anim_controller.play("jump")
		velocity.y += gravity * delta
		coyote_timer -= delta
	else:
		coyote_timer = coyote_time

# Move the player, left and right
func move_player(delta) -> void:
	# --- HORIZONTAL MOVEMENT ---
	var input_x = 0
	
	# Check the logical actions defined in the input manager
	var move_left = input_manager.is_action_pressed("move_left")
	var move_right = input_manager.is_action_pressed("move_right")
	var move_up = input_manager.is_action_pressed("move_up")
	var move_down = input_manager.is_action_pressed("move_down")
	
	input_x = int(move_right) - int(move_left)
		
	var target_speed = input_x * speed
	
	# Accelerate and decelerate the character's velocity based on input direction.
	if (is_on_floor()):
		if (input_x != 0):
			velocity.x = move_toward(velocity.x, target_speed, acceleration * delta)
			player_anim_controller.play("walk")
		else:
			velocity.x = move_toward(velocity.x, 0, deceleration * delta)
			player_anim_controller.play("idle")
	else: 
		if (input_x != 0):
			velocity.x = move_toward(velocity.x, target_speed, air_acceleration * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, air_deceleration * delta)

# Jump for the player, noraml and long jump
func jump(delta) -> void:
		# Cut the jump short if button is released and character is still rising.
	if (input_manager.is_action_just_released("jump") and velocity.y < 0):
		velocity.y = velocity.y / jump_cut_gravity_multiplier
		
		# --- JUMP BUFFER ---
	if (Input.is_action_just_pressed("jump") and is_on_floor()):
		# If the jump was just pressed, buffer the command.
		jump_buffer_timer = jump_buffer_time
	else:
		# Start the timer to countdown every frame jump was not pressed.
		jump_buffer_timer -= delta
		
		if (input_manager.is_action_just_pressed("use_item")):
			InventoryManager.use_item(0)
			
	# --- EXECUTE JUMP ---
	# Coyote time is used here so if a jump is executed just before landing
	# we accept the jump. More forgiving that way.
	if ((coyote_timer > 0 or is_on_floor()) and jump_buffer_timer > 0):
		velocity.y = -jumpForce
		player_anim_controller.play("jump")
		
		# Reset the timers to prevent double jumps.
		coyote_timer = 0
		jump_buffer_timer = 0
		
		# TODO: Add sound here!
