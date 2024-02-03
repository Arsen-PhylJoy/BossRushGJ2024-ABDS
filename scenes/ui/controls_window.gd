extends MarginContainer

@onready var _blur_dark_controls: Panel = %BlurDarkControls
@onready var _timer: Timer = Timer.new()
@onready var _close_button: Button = %Close
var _start_animation: bool = false

func _init(start_animation: bool = false) -> void:
	_start_animation = start_animation
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if _close_button.pressed.connect(_on_closed): printerr("Fail: ",get_stack())
	if(_start_animation == true):
		add_child(_timer)
		_timer.one_shot = true
		_timer.start(1.0)
	if(StoryState.is_player_has_dark_ability == true):
		_blur_dark_controls.material["shader_parameter/lod"] = 0

func _process(delta: float) -> void:
	if(_start_animation == true):
		_blur_dark_controls.material["shader_parameter/lod"] = lerpf(0,5.0,_timer.time_left)

func _on_closed()->void:
	queue_free()
