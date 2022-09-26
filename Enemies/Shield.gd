extends Area2D

onready var explosion: = preload("res://Projectiles/ShieldExplosion.tscn")
onready var animationPlayer: = $AnimationPlayer

export var HP = 20

var score_value1 = 99
var score_value2 = 7000
var damage = 50


func _ready() -> void:
	add_to_group("enemies")

func die() -> void:
	var main = get_tree().current_scene
	var explosion_fx = explosion.instance()
	main.add_child(explosion_fx)
	SoundPlayer.play_sound(SoundPlayer.ENEMY_DESTROYED)
	explosion_fx.global_position = global_position
	Global.score += score_value2
	queue_free()

func small_damage():
	HP -= 1
	animationPlayer.play("damage")
	if HP <= 0:
		die()

func big_damage():
	HP -= 5
	animationPlayer.play("damage")
	if HP <= 0:
		die()

func _on_Shield_body_entered(body) -> void:
	if body is Player and body.hitbox_active == true:
		body.player_damage(damage)

	elif body is Bullet:
		body.kill()
		small_damage()
		SoundPlayer.play_sound(SoundPlayer.SHIELDHIT)
		
	elif body is ChargeShot:
		body.kill()
		big_damage()
		SoundPlayer.play_sound(SoundPlayer.SHIELDHIT)
