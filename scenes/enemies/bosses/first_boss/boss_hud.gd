extends CanvasLayer


@onready var health_bar: TextureProgressBar = $HealthBar
@onready var boss_ref: FirstBoss = $".."


func _ready() -> void:
	if boss_ref.ready.connect(_on_boss_ready): printerr("Fail: ",get_stack())
	if boss_ref.health_changed.connect(_on_boss_health_changed): printerr("Fail: ",get_stack())

func _on_boss_ready()->void:
	health_bar.max_value = boss_ref.health
	health_bar.value = boss_ref.health

func _on_boss_health_changed(max_health: float, actual_health:float)->void:
	health_bar.max_value = max_health
	health_bar.value = actual_health
