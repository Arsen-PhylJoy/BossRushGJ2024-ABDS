extends RigidBody2D

@onready var visible_notifier : VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@export var damange = 30
@export var explosion_VFX: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	contact_monitor = true;
	max_contacts_reported = 4;
	connect("body_entered", _on_body_entered)
	visible_notifier.connect("screen_exited", _on_visible_on_screen_notifier_2d_screen_exited)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body: Node):
	var explosion_VFX_instance = explosion_VFX.instantiate()
	explosion_VFX_instance.position = body.global_position
	get_parent().add_child(explosion_VFX_instance)
	explosion_VFX_instance.emitting = true
	await get_tree().create_timer(0.1).timeout
	queue_free()
	explosion_VFX_instance.queue_free()
