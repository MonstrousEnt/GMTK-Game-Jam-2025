@tool
class_name SpawnPoint
extends Node2D


@export var debug_draw: bool = false


var player_animations_path: String = "res://assets/resources/player_sprite_frames.tres"
var player_debug_sprite: AnimatedSprite2D


##
## BUILT IN METHODS
##


func _enter_tree() -> void:
	if !Engine.is_editor_hint():
		return

	var player_animations = load(player_animations_path) as SpriteFrames
	player_debug_sprite = AnimatedSprite2D.new()
	player_debug_sprite.modulate = Color(1, 1, 1, 0.5)
	player_debug_sprite.sprite_frames = player_animations
	self.add_child(player_debug_sprite)
	player_debug_sprite.play("idle")


func _exit_tree() -> void:
	if !Engine.is_editor_hint():
		return

	if player_debug_sprite is AnimatedSprite2D:
		player_debug_sprite.queue_free()


func _draw() -> void:
	if !Engine.is_editor_hint() && !debug_draw:
		return

	var color = Color.LIME_GREEN
	var width = 1

	var radius = 16
	draw_line(Vector2(0, radius), Vector2(0, -radius), color, width)
	draw_line(Vector2(radius, 0), Vector2(-radius, 0), color, width)

