extends Area2D

var count : int = 0

onready var explosion: = preload("res://Projectiles/Explosion.tscn")
onready var damage = 25

export var HP_CoreBullet = 3
export var HP_CoreMissile = 3
export var HP_CoreLaser = 3
var HP_Total = HP_CoreBullet + HP_CoreMissile + HP_CoreLaser

var hitCoreBullet = false
var hitCoreMissile = false
var hitCoreLaser = false

func _process(delta: float) -> void:
	count += 1
	if count >= 180:
		count = 0

func die() -> void:
	var main = get_tree().current_scene
	var explosion_fx = explosion.instance()
	main.add_child(explosion_fx)
	SoundPlayer.play_sound(SoundPlayer.ENEMY_DESTROYED)
	explosion_fx.global_position = global_position
	queue_free()

func small_damage():
	if hitCoreBullet and HP_CoreBullet > 0:
		HP_CoreBullet -= 1
		hitCoreBullet = false
		
	if hitCoreMissile and HP_CoreMissile > 0:
		HP_CoreMissile -= 1
		hitCoreMissile = false
		
	if hitCoreLaser and HP_CoreLaser > 0:
		HP_CoreLaser -= 1
		hitCoreLaser = false
		
	HP_Total = HP_CoreBullet + HP_CoreMissile + HP_CoreLaser
	print("HP_Total is:")
	print(HP_Total)
	
	#animationPlayer.play("Damage")
	if HP_Total <= 0:
		#die()
		print("Boss Died")

func big_damage():
	if hitCoreBullet and HP_CoreBullet > 0:
		HP_CoreBullet -= 3
		hitCoreBullet = false
		
	if hitCoreMissile and HP_CoreMissile > 0:
		HP_CoreMissile -= 3
		hitCoreMissile = false
		
	if hitCoreLaser and HP_CoreLaser > 0:
		HP_CoreLaser -= 3
		hitCoreLaser = false
	
	HP_Total = HP_CoreBullet + HP_CoreMissile + HP_CoreLaser
	print("HP_Total is:")
	print(HP_Total)
	
	#animationPlayer.play("Damage")
	if HP_Total <= 0:
		#die()
		print("Boss Died")

func _on_CoreBullet_body_entered(body):
	print("Bullet hit CB")
	if body is Bullet:
		hitCoreBullet = true
		body.kill()
		small_damage()
	elif body is ChargeShot:
		hitCoreBullet = true
		body.kill()
		big_damage()


func _on_CoreMissile_body_entered(body):
	print("Bullet hit CM")
	if body is Bullet:
		hitCoreMissile = true
		body.kill()
		small_damage()
	elif body is ChargeShot:
		hitCoreMissile = true
		body.kill()
		big_damage()


func _on_CoreLaser_body_entered(body):
	print("Bullet hit CL")
	if body is Bullet:
		hitCoreLaser = true
		body.kill()
		small_damage()
	elif body is ChargeShot:
		hitCoreLaser = true
		body.kill()
		big_damage()
