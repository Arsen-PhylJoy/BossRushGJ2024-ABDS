@tool
extends BTCondition
## HasToKill


# Called each time this task is ticked (aka executed).
func _tick(_delta: float) -> Status:
	if(StoryState.is_rematch== false):
		return SUCCESS
	return FAILURE



