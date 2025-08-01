extends AnimatedSprite2D

# Play's an animation based on it's name and prevents the animation
# from restarting every frame.
func play_animation(anim: String):
	if animation != anim:
		play(anim)
