tool
extends Node2D

export(PackedScene) var entity;
export(float, 1, 100) var speed;
export(Color) var color setget set_color;

var stopped := false
var is_reset := false

func set_color(_color):
	print("called")
	color = _color
	#$PreviewLine.default_color = color
	$Sprite.modulate = color
	$PreviewLine.default_color = color
	$PreviewLine2.default_color = color

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite/AnimationPlayer.play("flash")
	calibrate_path()
	$Sprite.position = $Path2D.curve.get_point_position(0)
	if !Engine.editor_hint:
		reset()
		Game.connect("game_start", self, "start")
		Game.connect("game_reset", self, "reset")
		Game.connect("game_lost", self, "lost")

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
		$PreviewLine.points = pool
		$PreviewLine2.points = pool
	else:
		$PreviewLine.points = $Path2D.curve.tessellate()
		$PreviewLine2.points = $Path2D.curve.tessellate()
	$Sprite.position = $Path2D.curve.get_point_position(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.editor_hint:
		calibrate_path()
	else:
		pass

func spawnEntity():
	var entity_scene = entity.instance()
	entity_scene.stopped = stopped;
	$Entities.add_child(entity_scene);

func start():
	is_reset = false
	$SpawnOffset.start()
	$PreviewLine.visible = false
	$PreviewLine2.visible = false
	yield($SpawnOffset, "timeout")
	if !is_reset:
		spawnEntity()
		$SpawnInterval.start()

func reset():
	is_reset = true
	for child in $Entities.get_children():
		$Entities.remove_child(child)
	$SpawnInterval.stop()
	$PreviewLine.visible = true
	$PreviewLine2.visible = true
	stopped = false

func lost():
	$SpawnInterval.stop()

func _on_SpawnInterval_timeout():
	spawnEntity()
