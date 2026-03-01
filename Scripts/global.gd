extends Node

var RNG = RandomNumberGenerator.new()
var cloud_textures = [preload("res://Assets/Background/Clouds/Cloud1.png"), preload("res://Assets/Background/Clouds/Cloud2.png"), preload("res://Assets/Background/Clouds/Cloud3.png")]
var building_textures = [preload("res://Assets/Background/Buildings/House.png"), preload("res://Assets/Background/Buildings/Skyscraper1.png"), preload("res://Assets/Background/Buildings/Skyscraper2.png")]
var power_up_textures = [preload("res://Assets/Power-ups/Plus_3.png"), preload("res://Assets/Power-ups/Close_pipes.png"), preload("res://Assets/Power-ups/Fast_pipes.png")]

var spd = 1.5
var pipe_speed = spd
var pipe_distance = 27
var game_ended = false
var game_just_ended = false
var score = 100
var max_score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	RNG.randomize()

# Maps a number from a the [start, stop] range to the [final_start, final_stop] range
func map_value(value, start, stop, final_start, final_stop):
	start = float(start)
	stop = float(stop)
	final_start = float(final_start)
	final_stop = float(final_stop)
	
	var mapped_value = value
	
	# Percentage of the number in its original range
	var percent = value / (start + stop)
	
	mapped_value = (final_start + final_stop) * percent
	
	return mapped_value
