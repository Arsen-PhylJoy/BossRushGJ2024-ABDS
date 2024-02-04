class_name LoadingScreen extends CanvasLayer

signal transition_in_ended

@onready var anim_player: AnimationPlayer = %AnimationPlayer

var starting_animation_name:String
	
func start_transition(animation_name:String) -> void:
	if !anim_player.has_animation(animation_name):
		push_warning("'%s' animation does not exist" % animation_name)
		animation_name = "fade_to_black"
	starting_animation_name = animation_name
	anim_player.play(animation_name)
	await anim_player.animation_finished
	transition_in_ended.emit()
	
# called by SceneManger to play the outro to the transition once the content is loaded
func finish_transition() -> void:
	# construct second half of the transitation's animation name
	var ending_animation_name:String = starting_animation_name.replace("to","from")
	if !anim_player.has_animation(ending_animation_name):
		push_warning("'%s' animation does not exist" % ending_animation_name)
		ending_animation_name = "fade_from_black"
	anim_player.play(ending_animation_name)
	await anim_player.animation_finished
	get_tree().paused = false
	queue_free()
