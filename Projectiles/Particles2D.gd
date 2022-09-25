extends Particles2D

onready var parent = get_parent()

func _process(delta):
	emitting = false
	if parent.emitting == true:
		emitting = true
