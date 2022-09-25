extends KinematicBody2D
class_name Bullet

onready var hitEffect: = preload("res://Projectiles/HitEffect.tscn")

export var SPEED: = 1000

var velocity = Vector2.RIGHT
var amount = 1

func _process(delta):
	move_and_collide(velocity.normalized() * SPEED * delta)

func kill()->void:
	create_hit_effect()
	queue_free()

func create_hit_effect():
	var main = get_tree().current_scene
	var hit = hitEffect.instance()
	main.add_child(hit)
	hit.position = global_position
