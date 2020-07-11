extends Control

func _ready():
	Game.connect("game_over", self, "_on_game_over");

func _on_ExitButton_pressed():
	get_tree().quit();
	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		_on_ExitButton_pressed()

func _on_StartButton_pressed():
	visible = false
	set_process(false)
	Game.set_process(true)
	Game.loadLevel("res://src/scenes/levels/Level1.tscn")

func _on_game_over():
	visible = true
	set_process(true)
	Game.set_process(false)
