extends TileMap

class_name Level

export(String) var level_name
export(PackedScene) var next_level
export(int, 10, 100000) var target_score

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
