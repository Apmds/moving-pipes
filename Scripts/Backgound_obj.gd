extends Sprite


# Declare member variables here. Examples:
export var type = 0 # 0 for building, 1 for cloud
var speed

# Called when the node enters the scene tree for the first time.
func _ready():
	if type == 0:
		var index = Global.RNG.randi_range(0, len(Global.building_textures)-1)
		texture = Global.building_textures[index]
		scale.x = 3
		scale.y = 3
		position.y = 495-(scale.y*texture.get_height()/2)
		speed = Global.pipe_speed*0.8
	elif type == 1:
		var index = Global.RNG.randi_range(0, len(Global.cloud_textures)-1)
		texture = Global.cloud_textures[index]
		scale.x = 2
		scale.y = 2
		position.y = Global.RNG.randi_range(70, 300)
		speed = Global.pipe_speed*Global.RNG.randf_range(0.1, 0.8)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not Global.game_ended:
		position.x -= speed
		if position.x <= -100:
			queue_free()
