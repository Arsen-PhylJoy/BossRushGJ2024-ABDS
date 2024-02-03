class_name ControlsWindow
extends PanelContainer

@onready var _hide_dark_controls: Panel = %HideDarkControls
@onready var _timer: Timer = Timer.new()
@onready var _close_button: Button = %Close
var start_animation: bool = false
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if _close_button.pressed.connect(_on_closed): printerr("Fail: ",get_stack())
	if(start_animation == true):
		add_child(_timer)
		_timer.one_shot = true
		_timer.start(1.0)
	if(StoryState.is_player_has_dark_ability == true):
		(_hide_dark_controls.get_theme_stylebox("panel","Panel") as StyleBoxFlat).bg_color = Color(0,0,0,1.0)

func _process(delta: float) -> void:
	if(start_animation == true):
		(_hide_dark_controls.get_theme_stylebox("panel","Panel") as StyleBoxFlat).bg_color.a = lerpf(0,1.0,_timer.time_left)

func _on_closed()->void:
	BossRushUtility.play_click_sound()
	queue_free()
