extends Node

# Level Ssytem Var
var currentUnlockLevel : Array[bool]

# Game Loop Var
var currentCompletedLevel : Array[bool]

#unlock a level
func unlockLevel(levelIndex: int) -> void:
	currentUnlockLevel[levelIndex] = true
	
#set the level to completed
func LevelCompleted(levelIndex: int) -> void:
	currentCompletedLevel[levelIndex] = true

#if all level are completed in order the game is completed	
func GameLoop() -> bool:
	var gameComepleted : bool = false
	
	for item in currentCompletedLevel:
		if (item == true):
			gameComepleted = true
		elif (item == false):
			gameComepleted = false 
	
	return gameComepleted
	
