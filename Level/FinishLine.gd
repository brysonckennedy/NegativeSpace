extends Area2D


func _on_FinishLine_body_entered(body):
	if body is Player:
		Events.emit_signal("you_win")
