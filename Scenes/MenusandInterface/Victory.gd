extends Control

func _ready():
	MusicPlayers.play_song(MusicPlayers.VICTORY)

func _on_StartButton_pressed():
	get_tree().change_scene("res://Level/MainLevel.tscn")

func _on_OptionsButton_pressed():
	pass # Replace with function body.


func _on_QuitButton_pressed():
	get_tree().quit()
