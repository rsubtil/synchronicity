tool
extends Node2D

export(PackedScene) var entity;
export(float, 1, 100) var speed;

var debug_line := Line2D.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	calibrate_path()
	debug_line.default_color = Color.magenta
	if !Engine.editor_hint:
		start()
	else:
		add_child(debug_line)

func calibrate_path():
	var pool : PoolVector2Array
	for i in range($Path2D.curve.get_point_count()):
		var pointPos = $Path2D.curve.get_point_position(i)
		if(pointPos.x > 0):
			pointPos.x = floor(pointPos.x / 32) * 32 + 16
		else:
			pointPos.x = ceil(pointPos.x / 32) * 32 + 16
		if(pointPos.y > 0):
			pointPos.y = floor(pointPos.y / 32) * 32 + 16
		else:
			pointPos.y = ceil(pointPos.y / 32) * 32 + 16
		
		if Engine.editor_hint:
			pool.append(pointPos)
		else:
			$Path2D.curve.set_point_position(i, pointPos)
	
	if Engine.editor_hint:
		debug_line.points = pool
	else:
		debug_line.points = $Path2D.curve.tessellate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.editor_hint:
		calibrate_path()
	else:
		pass

func spawnEntity():
	var entity_scene = entity.instance()
	$Entities.add_child(entity_scene);

func start():
	$SpawnOffset.start()
	yield($SpawnOffset, "timeout")
	spawnEntity()
	$SpawnInterval.start()


func _on_SpawnInterval_timeout():
	spawnEntity()
