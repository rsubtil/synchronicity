extends Control

var background = preload("res://src/scenes/MenuMap.tscn")
var curr_back

func _ready():
	loadBackground()
	Game.connect("game_over", self, "_on_game_over");

func _on_ExitButton_pressed():
	get_tree().quit();
	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		_on_ExitButton_pressed()

func loadBackground():
	curr_back = background.instance()
	add_child(curr_back)

func _on_StartButton_pressed():
	$CanvasLayer/Control.visible = false
	$CanvasLayer/LevelSelect.visible = true

func _on_game_over():
	visible = true
	$CanvasLayer/Control.visible = true
	$CanvasLayer/Panel.visible = true
	loadBackground()
	$AudioStreamPlayer.play()
	set_process(true)
	Game.set_process(false)


func _on_OptionsButton_pressed():
	$CanvasLayer/Control.visible = false
	$CanvasLayer/Settings.visible = true


func _on_BackButton_pressed():
	$CanvasLayer/Control.visible = true
	$CanvasLayer/Settings.visible = false
	$CanvasLayer/LevelSelect.visible = false

func loadLevel(level, is_tutorial = false):
	visible = false
	$CanvasLayer/Control.visible = false
	$CanvasLayer/Panel.visible = false
	$CanvasLayer/LevelSelect.visible = false
	set_process(false)
	Game.set_process(true)
	Game.loadLevel(load(level), is_tutorial)
	#$Tilemap.visible = false
	$AudioStreamPlayer.stop()
	remove_child(curr_back)
	curr_back.queue_free()

func _on_TutButton_pressed():
	loadLevel("res://src/scenes/levels/Tutorial.tscn", true)

func _on_Level1_pressed():
	loadLevel("res://src/scenes/levels/Level 1.tscn")

func _on_Level2_pressed():
	loadLevel("res://src/scenes/levels/Level 2.tscn")

func _on_Level3_pressed():
	loadLevel("res://src/scenes/levels/Level 3.tscn")

func _on_Level4_pressed():
	loadLevel("res://src/scenes/levels/Level 4.tscn")

func _on_Level5_pressed():
	loadLevel("res://src/scenes/levels/Level 5.tscn")

func _on_Level6_pressed():
	loadLevel("res://src/scenes/levels/Level 6.tscn")

func _on_Level7_pressed():
	loadLevel("res://src/scenes/levels/Level 7.tscn")

func _on_Level8_pressed():
	loadLevel("res://src/scenes/levels/Level 8.tscn")

func _on_Level9_pressed():
	loadLevel("res://src/scenes/levels/Level 9.tscn")

func _on_Level10_pressed():
	loadLevel("res://src/scenes/levels/Level 10.tscn")

func _on_Level11_pressed():
	loadLevel("res://src/scenes/levels/Level 11.tscn")

func _on_Level12_pressed():
	loadLevel("res://src/scenes/levels/Level 12.tscn")
