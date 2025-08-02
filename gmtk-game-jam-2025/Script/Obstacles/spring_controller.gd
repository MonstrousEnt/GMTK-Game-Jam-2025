extends Area2D

@export var spring_power: int = 800
@export var spring_duration: float = 0.5

#--- Function check's for collisions with player and applies spring effect. ---
func _on_body_entered(body) -> void:
	if body is Player:
		body.player_anim_controller.stop()
		body.is_sprung = true
		body.spring_timer = spring_duration
		# Apply direction to the player's velocity based on spring power.
		body.velocity.x = -cos(rotation + PI/2.0) * spring_power
		body.velocity.y = -sin(rotation + PI/2.0) * spring_power
