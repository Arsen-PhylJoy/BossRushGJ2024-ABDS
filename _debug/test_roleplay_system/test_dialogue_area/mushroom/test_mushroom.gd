extends Sprite2D

func _ready() -> void:
	$MushroomArea.connect("body_entered", _on_player_entered)
	
func _on_player_entered(body: Node2D) ->void:
	TestStoryState.is_mushroom_picked_up = true
	queue_free()
