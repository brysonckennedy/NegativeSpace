extends Node

onready var audioStreamPlayer: = $AudioStreamPlayer
onready var animationPlayer: = $AnimationPlayer

func _ready():
	Events.connect("boss_died", self, "_on_boss_died")

func _on_boss_died():
	animationPlayer.play("Wipe")
	if !audioStreamPlayer.playing:
		audioStreamPlayer.play()



func _on_AudioStreamPlayer_finished():
	get_tree().change_scene("res://Scenes/MenusandInterface/WinScreen.tscn")
