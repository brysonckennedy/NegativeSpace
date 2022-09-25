extends Area2D

onready var explosion: = preload("res://Projectiles/Explosion.tscn")
onready var animationPlayer: = $AnimationPlayer
onready var damage = 25

export(float) var SPEED = 100.0
export var HP = 3

func _ready() -> void:
	add_to_group("enemies")

func _process(delta: float) -> void:
	position.x -= SPEED * delta

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
	
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
	

func _on_SlidingEnemy_body_entered(body) -> void:
	if body is Player and body.hitbox_active == true:
		body.player_damage(damage)
		die()
	elif body is Bullet:
		body.kill()
		small_damage()
