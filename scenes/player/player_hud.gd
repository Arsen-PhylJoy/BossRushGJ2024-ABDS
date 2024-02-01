extends CanvasLayer

@onready var health_bar: TextureProgressBar = $Health
@onready var energy_bar: TextureProgressBar = $Energy
@onready var animation_player: AnimationPlayer = $AnimationPlayerUI

func _ready() -> void:
	if health_bar.value_changed.connect(_on_health_changed): printerr("Fail: ",get_stack())
	if energy_bar.value_changed.connect(_on_energy_changed): printerr("Fail: ",get_stack())

func _on_health_changed(value: float)->void:
	animation_player.play("on_health_changed")
	if(value == 0):
		animation_player.play("on_dead")

func _on_energy_changed(value: float)->void:
	if (value == energy_bar.min_value):
		animation_player.play("on_ability_used")
	else:
		animation_player.play("on_energy_gained")
