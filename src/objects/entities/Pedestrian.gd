extends Node2D

class_name Pedestrian

onready var path := $"../../Path2D"
onready var path_follow := PathFollow2D.new()
onready var speed = $"../..".speed

var stopped := false

func new():
	self.speed = speed


# Called when the node enters the scene tree for the first time.
func _ready():
	path.add_child(path_follow)
	path_follow.loop = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !stopped:
		position = path_follow.global_position
		rotation = path_follow.global_rotation
		path_follow.offset += delta * speed * 10
		if(is_equal_approx(path_follow.unit_offset, 1.0)):
			path_follow.queue_free()
			queue_free()

func _on_Area2D_area_entered(area):
	var cross_scene = load("res://src/objects/debug/Cross.tscn").instance()
	cross_scene.position = position
	$"..".add_child(cross_scene)

func semaphore_pass():
	stopped = false

func semaphore_stop():
	stopped = true
