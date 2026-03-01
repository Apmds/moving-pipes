tool
extends Node2D

signal power_up_grabbed(pw)
export var pipes_distance = 27.0
export var preview_mode = true
var power_up = -1 # 0 for +3, 1 for closer pipes, 2 for faster pipes

# Called when the node enters the scene tree for the first time.
func _ready():
	$Up_pipe.position.y = -64 - pipes_distance
	$Down_pipe.position.y = 64 + pipes_distance
	if preview_mode:
		modulate = Color(1, 1, 1, 0.63)
	else:
		modulate = Color(1, 1, 1, 1)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Up_pipe.position.y = -64 - pipes_distance
	$Down_pipe.position.y = 64 + pipes_distance
	if preview_mode:
		modulate = Color(1, 1, 1, 0.63)
	else:
		modulate = Color(1, 1, 1, 1)
	
	if not Engine.editor_hint:
		if not preview_mode:
			if not Global.game_ended:
				position.x -= Global.pipe_speed
				if position.x <= -50:
					queue_free()
		else:
			position.y = clamp(get_global_mouse_position().y, 150, 330)
			if Global.game_ended:
				visible = false

func _on_Pipe_body_entered(body):
	if not Global.game_ended:
		$Hit_pipe.play()
		Global.game_ended = true
		Global.game_just_ended = true

func _on_Play_pipe_body_entered(body):
	Global.score -= 1

func set_power_up(new_value):
	if power_up == new_value:
		return
	power_up = new_value
	if power_up == -1:
		$"Power-up".texture = null
	else:
		$"Power-up".texture = Global.power_up_textures[power_up]


func _on_Power_up_area_body_entered(body):
	if power_up == 0:
		Global.score += 4
		emit_signal("power_up_grabbed", power_up)
	elif power_up == 1:
		emit_signal("power_up_grabbed", power_up)
	elif power_up == 2:
		emit_signal("power_up_grabbed", power_up)
	
	set_power_up(-1)
