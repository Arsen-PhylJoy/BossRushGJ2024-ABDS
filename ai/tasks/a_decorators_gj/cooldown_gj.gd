@tool
extends BTCooldown
## CooodownGj

@export var blackboard_cooldown: String

# Called once during initialization.
func _enter() -> void:
	duration = blackboard.get_data().get(blackboard_cooldown)

func _tick(_delta:float)->Status:
	print(elapsed_time)
	return SUCCESS
