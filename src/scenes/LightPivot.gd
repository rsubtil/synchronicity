extends Position2D

export(float, 1, 100) var speed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func reset():
	rotation_degrees = 0;

func _process(delta):
	rotation_degrees += delta * speed
