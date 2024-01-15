extends RigidBody2D

@onready var visible_notifier : VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

# Called when the node enters the scene tree for the first time.
func _ready():
	contact_monitor = true;
	max_contacts_reported = 4;
	connect("body_entered", _on_body_entered)
	visible_notifier.connect("screen_exited", _on_visible_on_screen_notifier_2d_screen_exited)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body: Node):
	queue_free()
