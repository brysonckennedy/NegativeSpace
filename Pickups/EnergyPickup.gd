extends Area2D

export var amount: = 25

export(float) var SPEED = 75.0

func _process(delta: float) -> void:
	position.x -= SPEED * delta

func _on_EnergyPickup_body_entered(body):
	if body is Player:
		body.heal(amount)
		queue_free()
