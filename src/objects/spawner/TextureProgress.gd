extends TextureProgress


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	reset()
	#rect_position += $"..".position

func reset():
	set_process(false)
	value = 0
	

func _process(delta):
	var timerNode = $"../../SpawnInterval"
	value = (1 - (timerNode.time_left / timerNode.wait_time)) * 100
