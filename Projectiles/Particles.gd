extends Particles2D

func _ready():
	emitting = true
	
	if !emitting:
		queue_free()
