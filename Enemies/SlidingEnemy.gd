extends Area2D

onready var damage = 25

export(float) var SPEED = 100.0

func _ready() -> void:
	add_to_group("enemies")

func _process(delta: float) -> void:
	position.x -= SPEED * delta

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
	
func die() -> void:
	var main = get_tree().current_scene
	queue_free()
	
func _on_SlidingEnemy_body_entered(body) -> void:
	if body is Player and body.hitbox_active == true:
		body.player_damage(damage)
		die()
