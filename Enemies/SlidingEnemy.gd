extends Area2D

onready var explosion: = preload("res://Projectiles/Explosion.tscn")
onready var animationPlayer: = $AnimationPlayer
onready var damage = 30

export(float) var SPEED = 100.0
export var HP = 3
export var SHIELD = true

var shift = false

func _ready() -> void:
	add_to_group("enemies")
	Events.connect("shift", self, "_on_shift")

func _process(delta: float) -> void:
	position.x -= SPEED * delta

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

func _on_shift():
	if shift == false:
		shift = true
		if SHIELD:
			animationPlayer.play("BlueShield")
		else:
			animationPlayer.play("BlueCore")
	elif shift == true:
		shift = false
		if SHIELD:
			animationPlayer.play("RedShield")
		else:
			animationPlayer.play("RedCore")

func die() -> void:
	var main = get_tree().current_scene
	var explosion_fx = explosion.instance()
	main.add_child(explosion_fx)
	SoundPlayer.play_sound(SoundPlayer.ENEMY_DESTROYED)
	explosion_fx.global_position = global_position
	queue_free()

func small_damage():
	HP -= 1
	animationPlayer.play("Damage")
	if HP <= 0:
		die()

func destroy_shield():
	SHIELD = false
	animationPlayer.play("Damage")
	if shift == true:
		animationPlayer.play("BlueCore")
	elif !shift:
		animationPlayer.play("RedCore")



func big_damage():
	HP -= 3
	animationPlayer.play("Damage")
	if HP <= 0:
		die()

func _on_SlidingEnemy_body_entered(body) -> void:
	if body is Player and body.hitbox_active == true:
		body.player_damage(damage)
		die()
		
	elif body is Bullet and SHIELD:
		body.kill()
		SoundPlayer.play_sound(SoundPlayer.SHIELDHIT)
		
	elif body is Bullet and !SHIELD:
		body.kill()
		small_damage()
		
	elif body is ChargeShot and SHIELD:
		body.kill()
		destroy_shield()
	
	elif body is ChargeShot and !SHIELD:
		body.spark()
		big_damage()
