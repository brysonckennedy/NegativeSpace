extends Area2D

export var amount: = 25

var score_value: = 125

export(float) var SPEED = 80.0

func _process(delta: float) -> void:
	position.x -= SPEED * delta

func _on_EnergyPickup_body_entered(body):
	if body is Player:
		body.heal(amount)
		SoundPlayer.play_sound(SoundPlayer.ENERGY_PICKUP)
		Global.score += score_value
		queue_free()
