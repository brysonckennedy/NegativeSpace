extends Control

func _on_StartButton_pressed():
	get_tree().change_scene("res://Scenes/Boss_Battle.tscn")

func _on_OptionsButton_pressed():
	pass # Replace with function body.


func _on_QuitButton_pressed():
	get_tree().quit()
