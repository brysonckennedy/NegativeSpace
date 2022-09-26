extends TileMap

export var SPEED: = 80

onready var animationPlayer: = $AnimationPlayer

var shift: = false

func _ready():
	animationPlayer.play("RESET")
	listen_quantum_shift()

func _physics_process(delta):
	position.x -= SPEED * delta

func listen_quantum_shift():
	Events.connect("shift", self, "_on_quantum_shift")

func _on_quantum_shift():
	if shift == true:
		shift = false
		animationPlayer.play("RESET")
		self_modulate.a = 0.50
		z_index = 0
		set_tileset(load("res://Level/Tiles/BackTiles.tres"))
		set_collision_layer_bit(2, 0)
		set_collision_layer_bit(3, 1)
		set_collision_mask_bit(0, 0)

	elif shift == false:
		shift = true
		animationPlayer.play("ColorShiftBlue")
		self_modulate.a = 1.00

		z_index = 5
		set_tileset(load("res://Level/Tiles/FrontTiles.tres"))
		set_collision_layer_bit(2, 1)
		set_collision_layer_bit(3, 0)
		set_collision_mask_bit(0, 1)

