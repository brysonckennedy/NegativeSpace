extends KinematicBody2D

var speed = 200
var motion = Vector2.ZERO
var player = null
var isSpotted = false
var shift = false
export(float) var SPEED = 6000.0
onready var explosion: = preload("res://Projectiles/Explosion.tscn")
onready var animationPlayer: = $AnimationPlayer
onready var damage = 10
export var HP = 3

var score_value = 2500

func _ready():
	Events.connect("shift", self, "_on_shift")

func _physics_process(delta):
	motion = Vector2.ZERO
	
	if player:
		motion = position.direction_to(player.position) * speed
	else:
		motion = Vector2(-SPEED * delta, 0)
	
	motion = move_and_slide(motion)

func die() -> void:
	var main = get_tree().current_scene
	var explosion_fx = explosion.instance()
	main.add_child(explosion_fx)
	SoundPlayer.play_sound(SoundPlayer.ENEMY_DESTROYED)
	explosion_fx.global_position = global_position
	Global.score += score_value
	queue_free()

func _on_shift():
	if shift == true:
		shift = false
	elif shift == false:
		shift = true

func _on_SightLine_body_entered(body):
	if body is Player:
		player = body
	if shift:
		animationPlayer.play("BlueOnSight")
	else:
		animationPlayer.play("RedOnSight")


func _on_SightLine_body_exited(body):
	player = null
	if shift:
		animationPlayer.play("Blue")
	else:
		animationPlayer.play("Red")

func small_damage():
	HP -= 1
	animationPlayer.play("Damage")
	if HP <= 0:
		die()

func big_damage():
	HP -= 3
	animationPlayer.play("Damage")
	if HP <= 0:
		die()

func _on_Hitbox_body_entered(body):
	if body is Player: #and body.hitbox_active == true:
		body.player_damage(damage)
		die()
	elif body is Bullet:
		body.kill()
		small_damage()
	elif body is ChargeShot:
		big_damage()



