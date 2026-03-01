extends Control


func _on_Close_button_pressed():
	$Button_sound.play()
	yield($Button_sound, "finished")
	get_tree().change_scene("res://Scenes/Main_menu.tscn")
