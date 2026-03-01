extends KinematicBody2D

var gravity = 30
var velocity = Vector2(0, 0)
var flap_force = 2000
var max_up_speed = 500
var max_down_speed = 1000
var max_rotation_degrees = 45

var state = 0
var times = [0.57, 0.3, 0.65]
var destination_height = 300
var close_to_dest = true

# Called when the node enters the scene tree for the first time.
func _ready():
	_on_Flap_timer_timeout()
	$Flap_timer.start()
	$Sprite.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.y += gravity
	
	# Cap speed
	if velocity.y > max_down_speed:
		velocity.y = max_down_speed
	elif velocity.y < -max_up_speed:
		velocity.y = -max_up_speed
	
	# Stop the bird from going out of bounds
	if not Global.game_ended: 
		# If the bird is close to the destination point, flap in place
		if sqrt(pow(destination_height-position.y, 2)) < 85:
			change_state(0)
		else:
			if position.y < destination_height:
				change_state(2)
			else:
				# If the bird was close to the destination point last frame, then flap
				if close_to_dest:
					_on_Flap_timer_timeout()
				change_state(1)
		close_to_dest = sqrt(pow(destination_height-position.y, 2)) < 85
		
		if Input.is_action_just_pressed("place_pipe"):
			set_destination_height(get_global_mouse_position().y)
	
	# Move and rotate bird
	velocity = move_and_slide(velocity)
	$Sprite.rotation_degrees = Global.map_value(velocity.y, 0, max_down_speed, 0, max_rotation_degrees)
	
	if Global.game_ended:
		$Flap_timer.stop()
		$Sprite.stop()

func change_state(new_state):
	if state == new_state:
		return
	state = new_state
	$Flap_timer.wait_time = times[state]
	$Flap_timer.start()

# Flap
func _on_Flap_timer_timeout():
	velocity.y -= flap_force
	$Flap_sound.play()
	$Flap_timer.wait_time = times[state]

func set_destination_height(new_dest_height):
	if destination_height == new_dest_height:
		return
	
	destination_height = new_dest_height
	
	# Go up or down based on the new destination height
	if position.y < destination_height:
		change_state(2)
	else:
		change_state(1)
