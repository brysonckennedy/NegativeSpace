extends TileMap

export var SPEED: = 80

func _physics_process(delta):
	position.x -= SPEED * delta
