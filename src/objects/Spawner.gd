#tool
extends Node2D

export(PackedScene) var entity;
export(float, 1, 100) var speed;

# Called when the node enters the scene tree for the first time.
func _ready():
	start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.editor_hint:
		pass
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
