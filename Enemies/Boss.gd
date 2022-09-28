extends Area2D

var count : int = 0

onready var explosion: = preload("res://Projectiles/Explosion.tscn")
onready var missile: = preload("res://Projectiles/BossMissile.tscn")
onready var enemy: = preload("res://Enemies/SlidingEnemy.tscn")
onready var damage = 9

onready var coreMissle: = $CoreMissile
onready var coreBullet: = $CoreBullet
onready var coreEnemy: = $CoreEnemy
onready var MissileLaunchPosition: Position2D = $CoreMissile/MissileLaunchPosition
onready var enemySpawnPosition: Position2D = $CoreEnemy/EnemySpawnPosition
onready var bulletLaunchPosition: Position2D = $CoreBullet/BulletLaunchPosition
onready var bulletSprite: = $CoreBullet/Sprite
onready var missileSprite: = $CoreMissile/Sprite
onready var enemySprite: = $CoreEnemy/Sprite
onready var missileTimer: = $MissileTimer
onready var bulletTimer: = $BulletTimer
onready var laserTimer: = $EnemyTimer

export var HP_CoreBullet = 10
export var HP_CoreMissile = 10
export var HP_CoreLaser = 10
var HP_Total = HP_CoreBullet + HP_CoreMissile + HP_CoreLaser

var hitCoreBullet = false
var hitCoreMissile = false
var hitCoreLaser = false

var coreBulletDead = false
var coreMissleDead = false
var coreLaserDead = false

var coreBulledDied = false
var coreMissleDied = false
var coreLaserDied = false

# ----- GENERAL NOTES -----
# - Test comment
# - 

func _ready():
	MusicPlayers.play_song(MusicPlayers.BOSSTHEME)

func _process(delta: float) -> void:
	if missileTimer.time_left <= 0:
		missileTimer.start()
	if bulletTimer.time_left <= 0:
		bulletTimer.start()
	if laserTimer.time_left <= 0:
		laserTimer.start()
		
	
#	count += 1
#	print(count)
#	if count % 1200: #count is the amount of frames since start. BK computer is 240fps so this is 5 seconds, needs to be made for all systems or at least assume monitor is 60fps
#		print("hit 1200")
#		shoot_missile()

func die() -> void:
	var main = get_tree().current_scene
	var explosion_fx = explosion.instance()
	main.add_child(explosion_fx)
	SoundPlayer.play_sound(SoundPlayer.ENEMY_DESTROYED)
	explosion_fx.global_position = global_position
	queue_free()
	
func shoot_missile() -> void:
	var FireMissile = missile.instance()
	var main = get_tree().current_scene
	if !coreMissleDead:
		main.add_child(FireMissile)
		FireMissile.position = MissileLaunchPosition.global_position

func spawn_enemy() -> void:
	var spawnenemy = enemy.instance()
	var main = get_tree().current_scene
	if !coreLaserDead:
		main.add_child(spawnenemy)
		spawnenemy.position = enemySpawnPosition.global_position

func shoot_bullet() -> void:
	var FireMissile = missile.instance()
	var main = get_tree().current_scene
	if !coreBulletDead:
		main.add_child(FireMissile)
		FireMissile.position = bulletLaunchPosition.global_position

func small_damage():
	if hitCoreBullet and HP_CoreBullet > 0:
		HP_CoreBullet -= 1
		hitCoreBullet = false
		if HP_CoreBullet <= 0:
			coreBulletDead = true
		
	if hitCoreMissile and HP_CoreMissile > 0:
		HP_CoreMissile -= 1
		hitCoreMissile = false
		if HP_CoreMissile <= 0:
			coreMissleDead = true
		
	if hitCoreLaser and HP_CoreLaser > 0:
		HP_CoreLaser -= 1
		hitCoreLaser = false
		if HP_CoreLaser <= 0:
			coreLaserDead = true
			
	if coreBulletDead:
		if !coreBulledDied:
			coreBullet.queue_free()
			print("bulletDead")
			coreBulledDied = true
	if coreMissleDead:
		if !coreMissleDied:
			coreMissle.queue_free()
			coreMissleDied = true
	if coreLaserDead:
		if !coreLaserDied:
			coreEnemy.queue_free()
			coreLaserDied = true
	HP_Total = HP_CoreBullet + HP_CoreMissile + HP_CoreLaser
	print("HP_Total is:")
	print(HP_Total)
	
	#animationPlayer.play("Damage")
	if HP_Total <= 0:
		#die()
		print("Boss Died")
		Events.emit_signal("boss_died")
		yield(get_tree().create_timer(3.0), "timeout")
		pass
		
		

func big_damage():
	if hitCoreBullet and HP_CoreBullet > 0:
		HP_CoreBullet -= 5
		hitCoreBullet = false
		if HP_CoreBullet <= 0:
			coreBulletDead = true
		
	if hitCoreMissile and HP_CoreMissile > 0:
		HP_CoreMissile -= 5
		hitCoreMissile = false
		if HP_CoreMissile <= 0:
			coreMissleDead = true
		
	if hitCoreLaser and HP_CoreLaser > 0:
		HP_CoreLaser -= 5
		hitCoreLaser = false
		if HP_CoreLaser <= 0:
			coreLaserDead = true
			
	if coreBulletDead:
		if !coreBulledDied:
			coreBullet.queue_free()
			print("bulletDead")
			coreBulledDied = true
	if coreMissleDead:
		if !coreMissleDied:
			coreMissle.queue_free()
			coreMissleDied = true
	if coreLaserDead:
		if !coreLaserDied:
			coreEnemy.queue_free()
			coreLaserDied = true
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
	if body is Bullet:
		hitCoreLaser = true
		body.kill()
		small_damage()
	elif body is ChargeShot:
		hitCoreLaser = true
		body.kill()
		big_damage()
	print("Bullet hit CL")


func _on_MissileTimer_timeout():
	shoot_missile()
	missileTimer.start()


func _on_BulletTimer_timeout():
	shoot_bullet()
	bulletTimer.start()


func _on_LaserTimer_timeout():
	spawn_enemy()
	laserTimer.start()
