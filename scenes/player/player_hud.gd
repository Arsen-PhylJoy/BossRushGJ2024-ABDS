extends CanvasLayer



@onready var _health_bar: TextureProgressBar = $Health
@onready var _energy_bar: TextureProgressBar = $Energy
@onready var _animation_player: AnimationPlayer = $AnimationPlayerUI
@onready var _player_ref: PlayerCharacter = $".."

func _ready() -> void:
	if(StoryState.is_player_has_dark_ability == false):
		_energy_bar.hide()
	if _player_ref.ready.connect(_on_player_ready): printerr("Fail: ",get_stack())
	if _player_ref.health_changed.connect(_on_player_health_changed): printerr("Fail: ",get_stack())
	if _player_ref.energy_changed.connect(_on_player_energy_changed): printerr("Fail: ",get_stack())
	if _health_bar.value_changed.connect(_on_health_changed): printerr("Fail: ",get_stack())
	if _energy_bar.value_changed.connect(_on_energy_changed): printerr("Fail: ",get_stack())

func _on_player_ready()->void:
	_health_bar.set_value_no_signal(_player_ref.actual_life)
	_energy_bar.set_value_no_signal(_player_ref.stamina)
	
func _on_player_health_changed(max_health: float, actual_health:float)->void:
	_health_bar.max_value = max_health
	_health_bar.value = actual_health

func _on_player_energy_changed(max_energy: float, actual_energy:float)->void:
	_energy_bar.max_value = max_energy
	_energy_bar.value = actual_energy

func _on_health_changed(value: float)->void:
	_animation_player.play("on_health_changed")
	if(value == 0):
		_animation_player.play("on_dead")

func _on_energy_changed(value: float)->void:
	if (value == _energy_bar.min_value):
		_animation_player.play("on_ability_used")
	else:
		_animation_player.play("on_energy_gained")
