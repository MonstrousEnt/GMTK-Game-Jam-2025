"""
	Project Name: Edge of Origin
	Team Name: Edge of Origin Team
	Authors: Daniel, Max
	Created Date: August 3, 2025
	Last Updated: August 3, 2025
	Description: This is the class for exit a level.
	Notes: 
	Resources:
"""

class_name LevelExit extends Area2D

##
## BUILT IN METHODS
##

func _ready() -> void:
	_connect_signals()

func _exit_tree() -> void:
	_disconnect_signals()
	
func _on_body_entered(body: Node2D) -> void:
	if !(body is Player):
		return

	if GameManager.in_level:
		# LevelManager.current_level.level_data.completed = true
		# var current_level_idx = GameManager.levels.find(LevelManager.current_level.level_data)

		GameManager.unlock_next_level()
		GameManager.quit_level()
		UIManager.update_pause_menus()


		# # Return if current level isnt found
		# if current_level_idx <= -1:
		# 	return
		#
		# # Return if no next level to unlock
		# if current_level_idx + 1 >= GameManager.levels.size():
		# 	return
		#
		# GameManager.levels[current_level_idx + 1].unlocked = true

##
## SIGNAL METHODS
##

func _connect_signals() -> void:
	self.body_entered.connect(_on_body_entered)

func _disconnect_signals() -> void:
	self.body_entered.disconnect(_on_body_entered)
