extends Area2D

var player = null
var damage = 10
var hasFoundPlayer = false

func _process(delta):
	look_at(get_global_transform(player.position))
	


func _on_BossBullet_body_entered(body):
	if body is Player and body.hitbox_active == true:
		body.player_damage(damage)


func _on_BossBullet_body_exited(body):
	queue_free()


func _on_Aim_body_entered(body):
	hasFoundPlayer = true
	player = body
