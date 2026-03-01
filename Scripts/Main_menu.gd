extends Control

# Declare member variables here. Examples:
var Game = preload("res://Scenes/Game.tscn")
var tutorial_menu = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("open_menu")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("menu")

func _on_Start_button_pressed():
	$Button_sound.play()
	$AnimationPlayer.play("close_menu")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene_to(Game)

func _on_Instructions_button_pressed():
	$Button_sound.play()
	$AnimationPlayer.play("open_tutorial")

func _on_Credits_button_pressed():
	$Button_sound.play()
	yield($Button_sound, "finished")
	get_tree().change_scene("res://Scenes/Credits.tscn")

func _on_Arrow_next_pressed():
	$Button_sound.play()
	
	if tutorial_menu == 1:
		$"Tutorial/Menu 1".visible = false
		$"Tutorial/Menu 2/Bird_sprite".play("default")
		$"Tutorial/Menu 2/Time_pipes".play("default")
		$"Tutorial/Menu 2/Pipes".play("default")
	elif tutorial_menu == 2:
		$"Tutorial/Menu 2".visible = false
		$"Tutorial/Menu 2/Bird_sprite".stop()
		$"Tutorial/Menu 2/Time_pipes".stop()
		$"Tutorial/Menu 2/Pipes".stop()
		
		$"Tutorial/Menu 3/Bird".play("default")
		$"Tutorial/Menu 3/Score".play("default")
	elif tutorial_menu == 3:
		$"Tutorial/Menu 3".visible = false
		$"Tutorial/Menu 3/Bird".stop()
		$"Tutorial/Menu 3/Score".stop()
	tutorial_menu += 1

func _on_Arrow_back_pressed():
	$Button_sound.play()
	
	if tutorial_menu == 2:
		$"Tutorial/Menu 1".visible = true
		$"Tutorial/Menu 2/Bird_sprite".stop()
		$"Tutorial/Menu 2/Time_pipes".stop()
		$"Tutorial/Menu 2/Pipes".stop()
	elif tutorial_menu == 3:
		$"Tutorial/Menu 2".visible = true
		$"Tutorial/Menu 2/Bird_sprite".play("default")
		$"Tutorial/Menu 2/Time_pipes".play("default")
		$"Tutorial/Menu 2/Pipes".play("default")
		
		$"Tutorial/Menu 3/Bird".stop()
		$"Tutorial/Menu 3/Score".stop()
	elif tutorial_menu == 4:
		$"Tutorial/Menu 3".visible = true
		
		$"Tutorial/Menu 3/Bird".play("default")
		$"Tutorial/Menu 3/Score".play("default")
	tutorial_menu -= 1

func _on_Tutorial_close_pressed():
	$Button_sound.play()
	$AnimationPlayer.play_backwards("open_tutorial")
	
	$Title.rect_position.y = 90
	$Bird.rotation_degrees = 45
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("menu")
