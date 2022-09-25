extends Area2D

var isInsideLaser = false

#this will be used to tick damage
func _process(delta):
	pass

#change rotation on transform when active. make sure rotatoin is relative to the end and not the center. currently if rotatedit would not work right.

#Used to check collision coming in
func _on_BossLaser_body_entered(body):
	isInsideLaser = true
	pass # Replace with function body.

#and collision coming out
func _on_BossLaser_body_exited(body):
	isInsideLaser = false
	pass # Replace with function body.
