extends Sprite

onready var path := $"../../Path2D"
onready var path_follow := PathFollow2D.new()
onready var speed = $"../..".speed

func new():
	self.speed = speed


# Called when the node enters the scene tree for the first time.
func _ready():
	path.add_child(path_follow)
	path_follow.loop = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = path_follow.global_position
	path_follow.offset += delta * speed * 10
	if(is_equal_approx(path_follow.unit_offset, 1.0)):
		path_follow.queue_free()
		queue_free()
