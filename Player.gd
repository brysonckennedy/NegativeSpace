extends KinematicBody2D

enum {
	MOVE,
	MAX_CHARGE
}

export var MAX_SPEED: = 1000000
export var ACCELERATION: = 500000
export var DECELERATION: = 5

onready var idleParticles:= $IdleParticles
onready var moveParticles:= $MoveParticles
onready var tween: = $Tween

var player_ready: = false
var state: = MOVE
var velocity: = Vector2.ZERO

func _ready() -> void:
	spawn()

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
	
	if not moving(input, delta):
		apply_decceleration(input, delta)
		idleParticles.emitting = true
		moveParticles.emitting = false
	else:
		velocity += input * ACCELERATION * delta
		velocity = velocity.clamped(MAX_SPEED * delta)
		idleParticles.emitting = false
		moveParticles.emitting = true
	
	move_and_slide(velocity * delta)
	

func apply_decceleration(input, delta):
	velocity -= velocity * DECELERATION * delta

func moving(input, delta):
	return input != Vector2.ZERO

func _on_Tween_tween_completed(_object: Object, _key: NodePath) -> void:
	player_ready = true
