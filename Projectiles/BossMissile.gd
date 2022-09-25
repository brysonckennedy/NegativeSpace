extends KinematicBody2D

var speed = 280
var motion = Vector2.ZERO
var player = null
var isSpotted = false
export(float) var SPEED = 6000.0
onready var explosion: = preload("res://Projectiles/Explosion.tscn")
onready var animationPlayer: = $AnimationPlayer
onready var damage = 25
export var HP = 3

# ----- GENERAL NOTES -----
# 
# - will probably have same problem of losing tracking when shifting
# - will fly straight again after losing tracking which looks a bit odd, but it might just be how it is
	
func _physics_process(delta):
	motion = Vector2.ZERO
	
	if player:
		motion = position.direction_to(player.position) * speed
		SPEED = 15000
	else:
		motion = Vector2(-SPEED * delta, 0)
	
	motion = move_and_slide(motion)

func die() -> void:
	var main = get_tree().current_scene
	var explosion_fx = explosion.instance()
	main.add_child(explosion_fx)
	SoundPlayer.play_sound(SoundPlayer.ENEMY_DESTROYED)
	explosion_fx.global_position = global_position
	queue_free()
	
	

func _on_Sightline_body_entered(body):
	if body is Player:
		player = body


func _on_Sightline_body_exited(body):
	player = null


func _on_Hitbox_body_entered(body):
	if body is Player: #and body.hitbox_active == true:
		body.player_damage(damage)
		die()
