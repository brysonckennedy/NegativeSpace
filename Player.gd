extends KinematicBody2D
class_name Player

signal health_updated(health)

enum {
	MOVE,
	MAX_CHARGE
}

export var MAX_SPEED: = 1000000
export var CMAX_SPEED: = 500000
export var ACCELERATION: = 100000
export var CACCELERATION: = 100000
export var DECELERATION: = 5
export var CDECELERATION: = 1
export var max_health: = 100
export var hitbox_active: = true

onready var bullet: = preload("res://Projectiles/Bullet.tscn")
onready var charge_shot: = preload("res://Projectiles/ChargeShot.tscn")

onready var idleParticles:= $IdleParticles
onready var moveParticles:= $MoveParticles
onready var tween: = $Tween
onready var invulnerabilityTimer: = $InvulnerabilityTimer
onready var effectsAnimation: = $EffectsAnimation
onready var collisionShape2D: = $CollisionShape2D
onready var healthBar: = $HUD/Control
onready var shotPosition: Position2D = $ShotPosition
onready var chargeUp: = $ChargeUp
onready var fullyCharged: = $FullyCharged
onready var chargeTimer: = $ChargeTimer
onready var chargeHoldSound: = $ChargeHoldSound
onready var chargingSound: = $ChargingSound

onready var health: = max_health setget _set_health

var player_ready: = false
var state: = MOVE
var velocity: = Vector2.ZERO
var shift: = false

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
	
	if Input.is_action_just_pressed("Shift"):
		quantum_shift()
	
	match state:
		MOVE: move_state(input, delta)
		MAX_CHARGE: max_charge_state(input, delta)
	

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
	

	if Input.is_action_just_pressed("Shoot"):
		chargeTimer.start()
		chargeUp.emitting = true
		if not chargingSound.playing:
			chargingSound.play()
	if Input.is_action_just_released("Shoot"):
		shoot(delta)
		chargeUp.emitting = false
	
	ground_collide()
	
	
	move_and_slide(velocity * delta)

func max_charge_state(input, delta) -> void:
	charge_sound_loop()
	chargeUp.emitting = false
	fullyCharged.visible = true
	fullyCharged.emitting = true
	if not moving(input):
		apply_cdecceleration(delta)
		idleParticles.emitting = true
		moveParticles.emitting = false
	else:
		velocity += input * CACCELERATION * delta
		velocity = velocity.limit_length(CMAX_SPEED * delta)
		idleParticles.emitting = false
		moveParticles.emitting = true
	
	if Input.is_action_just_released("Shoot"):
		shoot_charge_shot(delta)
	
	ground_collide()
	
	move_and_slide(velocity * delta)

func apply_decceleration(delta):
	velocity -= velocity * DECELERATION * delta

func apply_cdecceleration(delta):
	velocity -= velocity * CDECELERATION * delta

func moving(input):
	return input != Vector2.ZERO

func shoot(delta)->void:
	chargingSound.stop()
	chargeTimer.stop()
	var shoot = bullet.instance()
	var main = get_tree().current_scene
	main.add_child(shoot)
	shoot.position = shotPosition.global_position
	SoundPlayer.play_sound(SoundPlayer.SMALL_LASER)

func shoot_charge_shot(delta):
	chargeHoldSound.stop()
	fullyCharged.visible = false
	var shootcharge = charge_shot.instance()
	var main = get_tree().current_scene
	main.add_child(shootcharge)
	shootcharge.position = shotPosition.global_position
	SoundPlayer.play_sound(SoundPlayer.CHARGESHOT)
	fullyCharged.emitting = false
	state = MOVE

func quantum_shift():
	Events.emit_signal("shift")
	SoundPlayer.play_sound(SoundPlayer.QUANTUMSHIFT)
	if shift == true:
		shift = false
	else:
		shift = true

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
#		emit_signal("health_updated", health)
		if health == 0:
			die()

func ground_collide():
	if is_on_wall():
		die()

func disable_hitbox():
	hitbox_active = false

func enable_hitbox():
	hitbox_active = true

func _on_Tween_tween_completed(_object: Object, _key: NodePath) -> void:
	player_ready = true

func _on_InvulnerabilityTimer_timeout():
	effectsAnimation.play("RESET")

func _on_ChargeTimer_timeout():
	print("MAX CHARGE!")
	state = MAX_CHARGE

func charge_sound_loop():
	if not chargeHoldSound.playing:
		chargeHoldSound.play()

