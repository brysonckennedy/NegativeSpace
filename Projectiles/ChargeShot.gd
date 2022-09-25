extends KinematicBody2D
class_name ChargeShot

onready var hitEffect: = preload("res://Projectiles/HitEffect.tscn")

export var SPEED: = 800

var velocity = Vector2.RIGHT
var amount = 3

func _process(delta):
	move_and_collide(velocity.normalized() * SPEED * delta)

func spark()->void:
	create_hit_effect()

func kill()->void:
	create_hit_effect()
	queue_free()

func create_hit_effect():
	var main = get_tree().current_scene
	var hit = hitEffect.instance()
	main.add_child(hit)
	hit.position = global_position

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
