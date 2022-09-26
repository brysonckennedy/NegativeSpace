extends Area2D

export var SPEED: = 80

func _physics_process(delta):
	position.x -= SPEED * delta

var scene: = preload("res://Scenes/MenusandInterface/NextLevelScreen.tscn")

func _on_WinBox_body_entered(body):
	if body is Player:
		print("detected")
		body.fighting_boss = true
		get_tree().change_scene_to(scene)
