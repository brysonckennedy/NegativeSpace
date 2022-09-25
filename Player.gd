extends KinematicBody2D
class_name Player

signal health_updated(health)

enum {
	MOVE,
	MAX_CHARGE
}

export var MAX_SPEED: = 1000000
export var ACCELERATION: = 500000
export var DECELERATION: = 5
export var max_health: = 100
export var hitbox_active: = true

onready var idleParticles:= $IdleParticles
onready var moveParticles:= $MoveParticles
onready var tween: = $Tween
onready var invulnerabilityTimer: = $InvulnerabilityTimer
onready var effectsAnimation: = $EffectsAnimation
onready var collisionShape2D: = $CollisionShape2D
onready var healthBar: = $HUD/Control

onready var health: = max_health setget _set_health

var player_ready: = false
var state: = MOVE
var velocity: = Vector2.ZERO

func _ready() -> void:
	spawn()
	$"/root/Global".register_player(self)

func _physics_process(delta: float) -> void:
	if not player_ready:
		return
	
	var input = Vector2.ZERO
	input.x = Input.get_axis("MoveLeft", "MoveRight")
	input.y = Input.get_axis("MoveUp", "MoveDown")
	input = input.normalized()
	
	match state:
		MOVE: move_state(input, delta)
	

func spawn() -> void:
	var init_position:= Vector2(-100, 200)
	var final_position:= Vector2(100, 200)
	var _t = tween.interpolate_property(
		self,
		"position",
		init_position,
		final_position,
		1.0,
		Tween.TRANS_CUBIC,
		Tween.EASE_OUT
		)
	var _st = tween.start()	

func move_state(input, delta) -> void:
	
	if not moving(input):
		apply_decceleration(delta)
		idleParticles.emitting = true
		moveParticles.emitting = false
	else:
		velocity += input * ACCELERATION * delta
		velocity = velocity.limit_length(MAX_SPEED * delta)
		idleParticles.emitting = false
		moveParticles.emitting = true
	
	move_and_slide(velocity * delta)
	

func apply_decceleration(delta):
	velocity -= velocity * DECELERATION * delta

func moving(input):
	return input != Vector2.ZERO

func player_damage(amount) -> void:
	if invulnerabilityTimer.is_stopped():
		invulnerabilityTimer.start()
		_set_health(health - amount)

		effectsAnimation.play("DamageTaken")
		effectsAnimation.queue("Invulnerability")

func heal(amount) -> void:
	_set_health(health + amount)

func die() -> void:
	Events.emit_signal("player_died")
	queue_free()

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		healthBar.set_value(float(health)/max_health * 100)
		emit_signal("health_updated", health)
		if health == 0:
			die()

func disable_hitbox():
	hitbox_active = false

func enable_hitbox():
	hitbox_active = true

func _on_Tween_tween_completed(_object: Object, _key: NodePath) -> void:
	player_ready = true

func _on_InvulnerabilityTimer_timeout():
	effectsAnimation.play("RESET")
