extends Node2D

var Pipe = preload("res://Scenes/Play_pipe.tscn")
var Background_obj = preload("res://Scenes/Backgound_obj.tscn")
var current_power_up = 0
var next_power_up = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.game_ended = false
	Global.game_just_ended = false
	Global.score = 100
	Global.pipe_distance = 27
	Global.pipe_speed = Global.spd
	
	$AnimationPlayer.play("start_game")
	$BG/BG_element_timer.start()
	$Pipe_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HUD/Pipe_time/Label.text = "" + "%.2f" % ($Pipe_timer.time_left)
	$HUD/Score/Label.text = "Score: " + str(Global.score)
	
	$Preview_pipe.pipes_distance = Global.pipe_distance
	$Preview_pipe.set_power_up(next_power_up)
	
	$HUD/Final_score.visible = Global.game_ended
	$HUD/Final_score.text = str(Global.score)
	
	if Global.game_just_ended:
		$HUD/Pipe_time/Label.visible = false
		$HUD/Score/Label.visible = false
		$Pipe_timer.stop()
		$BG/BG_element_timer.stop()
		$HUD/End_splash.visible = true
		$Tween.interpolate_property($HUD/End_splash, "color", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
		$Tween.start()
	
	if Global.game_ended:
		if $Bird.position.y > 600:
			get_tree().reload_current_scene()
	else:
		$Ground.position.x -= Global.pipe_speed
		if $Ground.position.x <= 756:
			$Ground.position.x = 768
	
	for pipe in $Pipes.get_children():
		if $Bird.position.x < pipe.get_node("Bird_position").global_position.x:
			$Bird.set_destination_height(pipe.position.y)
			break
	
	Global.game_just_ended = false

func _on_BG_element_timer_timeout():
	var bg_obj_instance = Background_obj.instance()
	
	if $BG/Buildings.get_child_count() > 10:
		bg_obj_instance.type = 1
	elif $BG/Clouds.get_child_count() > 10:
		bg_obj_instance.type = 0
	elif $BG/Buildings.get_child_count() >= 5: # Have more chance of spawning a cloud when there are many buildings
		var prob = Global.RNG.randf_range(0,1)
		if prob < 0.75:
			bg_obj_instance.type = 1
		else:
			bg_obj_instance.type = 0
	elif $BG/Clouds.get_child_count() >= 5: # Have more chance of spawning a building when there are many clouds
		var prob = Global.RNG.randf_range(0,1)
		if prob < 0.75:
			bg_obj_instance.type = 0
		else:
			bg_obj_instance.type = 1
	else:
		bg_obj_instance.type = Global.RNG.randi_range(0, 1)
	
	bg_obj_instance.position.x = 1100
	
	if bg_obj_instance.type == 0:
		$BG/Buildings.add_child(bg_obj_instance)
	elif bg_obj_instance.type == 1:
		$BG/Clouds.add_child(bg_obj_instance)

func _on_Pipe_timer_timeout():
	var pipe_instance = Pipe.instance()
	pipe_instance.pipes_distance = Global.pipe_distance
	pipe_instance.preview_mode = false
	pipe_instance.position = Vector2(980, clamp(get_global_mouse_position().y, 150, 330))
	pipe_instance.set_power_up(next_power_up)
	pipe_instance.connect("power_up_grabbed", self, "_on_Power_up_grabbed")
	$Pipes.add_child(pipe_instance)
	$Add_pipe_sound.play()
	
	var rnd = Global.RNG.randf()
	if $Power_up_timer.time_left != 0:
		next_power_up = -1
	else:
		if rnd < 0.60:
			next_power_up = -1
		elif rnd < 0.80:
			next_power_up = 0
		elif rnd < 0.90:
			next_power_up = 1
		else:
			next_power_up = 2

func _on_Tween_tween_completed(object, key):
	if $HUD/End_splash.color == Color(1, 1, 1, 1):
		$Tween.interpolate_property($HUD/End_splash, "color", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
		$Tween.start()
		yield($Tween, "tween_completed")
		$HUD/End_splash.visible = false

func _on_Main_menu_button_pressed():
	$Button_sound.play()
	yield($Button_sound, "finished")
	get_tree().change_scene("res://Scenes/Main_menu.tscn")

func _on_Power_up_grabbed(power_up):
	if power_up <= 0:
		return
	$Power_up_timer.wait_time = 5
	$Power_up_timer.start()
	
	current_power_up = power_up
	if current_power_up == 1:
		Global.pipe_distance = 20
	elif current_power_up == 2:
		Global.pipe_speed = Global.spd*2.5

func _on_Power_up_timer_timeout():
	if current_power_up == 1:
		Global.pipe_distance = 27
	elif current_power_up == 2:
		Global.pipe_speed = Global.spd
	
	current_power_up = 0
