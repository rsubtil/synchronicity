tool
extends Node2D

export(PackedScene) var entity;
export(float, 1, 100) var speed;

var debug_line;

# Called when the node enters the scene tree for the first time.
func _ready():
	var debug_line := Line2D.new()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.editor_hint:
		debug_line.points = $Path2D.curve.points
