extends Area2D

var count : int = 0

onready var explosion: = preload("res://Projectiles/Explosion.tscn")
onready var missile: = preload("res://Projectiles/BossMissile.tscn")
onready var damage = 25

onready var coreMissle: = $CoreMissile
onready var MissileLaunchPosition: Position2D = $CoreMissile/MissileLaunchPosition

export var HP_CoreBullet = 3
export var HP_CoreMissile = 3
export var HP_CoreLaser = 3
var HP_Total = HP_CoreBullet + HP_CoreMissile + HP_CoreLaser

var hitCoreBullet = false
var hitCoreMissile = false
var hitCoreLaser = false

# ----- GENERAL NOTES -----
# 
# - 

func _process(delta: float) -> void:
	count += 1
	print(count)
	if count % 1200: #count is the amount of frames since start. BK computer is 240fps so this is 5 seconds, needs to be made for all systems or at least assume monitor is 60fps
		print("hit 1200")
		shoot_missile()

func die() -> void:
	var main = get_tree().current_scene
	var explosion_fx = explosion.instance()
	main.add_child(explosion_fx)
	SoundPlayer.play_sound(SoundPlayer.ENEMY_DESTROYED)
	explosion_fx.global_position = global_position
	queue_free()
	
func shoot_missile() -> void:
	print("firing missile")
	var FireMissile = missile.instance()
	var main = get_tree().current_scene
	main.add_child(FireMissile)
	FireMissile.position = MissileLaunchPosition.global_position

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



#------These functions check if hit by bullet and deal damage to core. cores have a total HP and each core has its own hp. All cores must die to triger death
#------death can be found in the damage functions under HP_Total <= 0 near bottom.
#------lots 

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
