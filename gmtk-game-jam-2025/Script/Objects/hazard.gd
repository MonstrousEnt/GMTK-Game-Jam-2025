class_name hazard
extends Area2D

# Any object of this class kills the player when they enter the radius.
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		# play sound and kill the player.
		body.queue_free()
		#TODO: Trigger game over screen or whatever.
