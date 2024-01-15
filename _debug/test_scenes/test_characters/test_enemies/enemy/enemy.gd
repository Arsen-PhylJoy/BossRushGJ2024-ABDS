extends CharacterBody2D

func  _ready() -> void:
	$HitBox.connect("body_entered", _on_something_entered_)
	
func _on_something_entered_(body: Node2D)->void:
	if(!body.has_method("_on_visible_on_screen_notifier_2d_screen_exited")):
		return
	$DialogueByEvent.show_dialog()
	DialogueManager.connect("dialogue_ended", _on_dialogue_ended_)

func _on_dialogue_ended_(dialogue: DialogueResource)->void:
	queue_free()
