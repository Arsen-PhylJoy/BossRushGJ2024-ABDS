@tool
extends BTAction
## KillPlayer

# Called each time this task is entered.
func _tick(_delta: float) -> Status:
	(agent as FirstBoss)._powerful_cooldown_timer.wait_time = 0.1
	(agent as FirstBoss).bury()
	for node: Node in (agent as FirstBoss).get_tree().current_scene.get_children():
		if(node is PlayerCharacter):
			(agent as FirstBoss)._powerful_cooldown_timer.wait_time = 6.0
			(agent as FirstBoss).powerful_attack((node as PlayerCharacter).global_position)
	return SUCCESS
