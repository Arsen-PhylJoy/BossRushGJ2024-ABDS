extends CanvasLayer

## The action to use for advancing the dialogue
const NEXT_ACTION: StringName = &"ui_accept"

## The action to use to skip typing the dialogue
const SKIP_ACTION: StringName = &"ui_cancel"

@export_category("Talking sound")
@export_enum("Good Guy","Bad Guy") var talk_sound_enum: String = "Good Guy"

@onready var balloon: Panel = %Balloon
@onready var character_label: RichTextLabel = %CharacterLabel
@onready var dialogue_label: DialogueLabel = %DialogueLabel
@onready var responses_menu: DialogueResponsesMenu = %ResponsesMenu
@onready var bad_guy_sound: AudioStreamPlayer = $BadGuySound
@onready var good_guy_sound: AudioStreamPlayer = $GoodGuySound
@onready var _talk_sound: AudioStreamPlayer

var _time_stamp_talking_sfx: float = 0.0

## The dialogue resource
var resource: DialogueResource

## Temporary game states
var temporary_game_states: Array = []

## See if we are waiting for the player
var is_waiting_for_input: bool = false

## See if we are running a long mutation and should hide the balloon
var will_hide_balloon: bool = false

## The current line
var dialogue_line: DialogueLine:
	set(next_dialogue_line):
		is_waiting_for_input = false
		balloon.focus_mode = Control.FOCUS_ALL
		balloon.grab_focus()

		# The dialogue has finished so close the balloon
		if not next_dialogue_line:
			get_tree().paused = false
			queue_free()
			return

		# If the node isn't ready yet then none of the labels will be ready yet either
		if not is_node_ready():
			await ready

		dialogue_line = next_dialogue_line

		character_label.visible = not dialogue_line.character.is_empty()
		character_label.text = tr(dialogue_line.character, "dialogue")

		dialogue_label.hide()
		dialogue_label.dialogue_line = dialogue_line

		responses_menu.hide()
		responses_menu.set_responses(dialogue_line.responses)

		# Show our balloon
		balloon.show()
		will_hide_balloon = false

		dialogue_label.show()
		if not dialogue_line.text.is_empty():
			dialogue_label.type_out()
			await dialogue_label.finished_typing

		# Wait for input
		if dialogue_line.responses.size() > 0:
			balloon.focus_mode = Control.FOCUS_NONE
			responses_menu.show()
		elif dialogue_line.time != "":
			var time: float = dialogue_line.text.length() * 0.02 if dialogue_line.time == "auto" else dialogue_line.time.to_float()
			await get_tree().create_timer(time).timeout
			next(dialogue_line.next_id)
		else:
			is_waiting_for_input = true
			balloon.focus_mode = Control.FOCUS_ALL
			balloon.grab_focus()
	get:
		return dialogue_line


func _ready() -> void:
	get_tree().paused = true
	balloon.hide()
	if(talk_sound_enum == "Good Guy"):
		_talk_sound = good_guy_sound
	else:
		_talk_sound = bad_guy_sound
	if balloon.gui_input.connect(_on_balloon_gui_input): printerr("Fail: ",get_stack())
	if DialogueManager.mutated.connect(_on_mutated): printerr("Fail: ",get_stack())
	if dialogue_label.spoke.connect(_on_spoke): printerr("Fail: ",get_stack())
	if dialogue_label.finished_typing.connect(_on_finished_spoke): printerr("Fail: ",get_stack())

func _unhandled_input(_event: InputEvent) -> void:
	# Only the balloon is allowed to handle input while it's showing
	get_viewport().set_input_as_handled()


## Start some dialogue
func start(dialogue_resource: DialogueResource, title: String, extra_game_states: Array = []) -> void:
	temporary_game_states =  [self] + extra_game_states
	is_waiting_for_input = false
	resource = dialogue_resource
	self.dialogue_line = await resource.get_next_dialogue_line(title, temporary_game_states)


## Go to the next line
func next(next_id: String) -> void:
	self.dialogue_line = await resource.get_next_dialogue_line(next_id, temporary_game_states)


### Signals


func _on_mutated(_mutation: Dictionary) -> void:
	is_waiting_for_input = false
	will_hide_balloon = true
	if get_tree().create_timer(0.1).timeout.connect(func()->void:
		if will_hide_balloon:
			will_hide_balloon = false
			balloon.hide()
	): printerr("Fail: ",get_stack()) 


func _on_balloon_gui_input(event: InputEvent) -> void:
	# See if we need to skip typing of the dialogue
	if dialogue_label.is_typing:
		@warning_ignore("confusable_local_declaration")
		@warning_ignore("int_as_enum_without_cast")
		var button_index: MouseButton = 0
		if( event is InputEventMouseButton):
			button_index = (event as InputEventMouseButton).button_index
		var mouse_was_clicked: bool = event is InputEventMouseButton and button_index == MOUSE_BUTTON_LEFT and event.is_pressed()
		var skip_button_was_pressed: bool = event.is_action_pressed(SKIP_ACTION)
		if mouse_was_clicked or skip_button_was_pressed:
			get_viewport().set_input_as_handled()
			dialogue_label.skip_typing()
			return

	if not is_waiting_for_input: return
	if dialogue_line.responses.size() > 0: return

	# When there are no response options the balloon itself is the clickable thing
	get_viewport().set_input_as_handled()
	@warning_ignore("confusable_local_declaration")
	@warning_ignore("int_as_enum_without_cast")
	var button_index: MouseButton = 0
	if( event is InputEventMouseButton):
		button_index = (event as InputEventMouseButton).button_index
	if event is InputEventMouseButton and event.is_pressed() and button_index == 1:
		next(dialogue_line.next_id)
	elif event.is_action_pressed(NEXT_ACTION) and get_viewport().gui_get_focus_owner() == balloon:
		next(dialogue_line.next_id)


func _on_responses_menu_response_selected(response: DialogueResponse) -> void:
	next(response.next_id)

func _on_spoke(letter:String, _letter_index:int, _speed:float)->void:
	print(_talk_sound.get_playback_position())
	if(_time_stamp_talking_sfx>30):
		_time_stamp_talking_sfx = 0.0
	if(!_talk_sound.playing):
		_talk_sound.play(_time_stamp_talking_sfx)

func _on_finished_spoke()->void:
	_talk_sound.stop()
