extends Node2D

signal game_start
signal game_reset
signal game_lost
signal game_over

enum Mode {
	CONTROL,
	SIMULATION,
}

var use_music_n := false

var current_mode = Mode.CONTROL setget set_current_mode

var score := 0 setget set_score
var target_score := 0

var next_level

export(float, 1, 25) var camera_speed

func set_score(_score):
	if target_score > 0 and is_processing():
		score = _score
		score = clamp(score, -1, target_score)
		var operand = (int(round(target_score / $AudioSystem.max_files)))
		var field = (score / operand) + 1
		$AudioSystem.setMusicLevel(field);
		set_score_text()
		if score == target_score:
			$CanvasLayer/Win.visible = true
			emit_signal("game_won")

func game_over(position : Vector2):
	if score != target_score and is_processing():
		$CPUParticles2D.global_position = position
		$CPUParticles2D.visible = true
		$AudioStreamPlayer2D.position = position
		$AudioStreamPlayer2D.play()
		$AudioSystem.stopAll()
		emit_signal("game_lost")

func _ready():
	set_process(false)

func set_score_text():
	$CanvasLayer/ColorRect/ScoreLabel.text = "Score: " + str(score) + "/" + str(target_score)

func set_current_mode(_current_mode):
	current_mode = _current_mode
	match current_mode:
		Mode.CONTROL:
			$CanvasLayer/StartButton.visible = true
			$CanvasLayer/ResetButton.visible = false
		Mode.SIMULATION:
			$CanvasLayer/StartButton.visible = false
			$CanvasLayer/ResetButton.visible = true

func loadLevel(level : PackedScene, is_tutorial):
	$Camera2D.smoothing_enabled = true
	set_visible(true)
	var level_scene = level.instance()
	next_level = level_scene.next_level
	for child in $CurrentGame.get_children():
		$CurrentGame.remove_child(child)
	
	$CurrentGame.add_child(level_scene)
	target_score = level_scene.target_score
	$CanvasLayer/StartButton.visible = true
	$CanvasLayer/ResetButton.visible = false
	$CanvasLayer/ColorRect.visible = true
	
	if is_tutorial:
		$CanvasLayer/TutorialPopup.popup_centered()
	
	if use_music_n:
		$AudioSystem.loadDynamicMusic("res://assets/music/SyncroniCityM", 4)
	else:
		$AudioSystem.loadDynamicMusic("res://assets/music/SyncroniCitym", 4)
	use_music_n = !use_music_n
	$AudioSystem.setMusicLevel(1)
	$AudioSystem.play()
	score = 0
	set_score_text()
	$CanvasLayer/ColorRect/NameLabel.text = "Level: " + level_scene.level_name

func _process(delta):
	handle_input(delta)
	
func handle_input(delta):
	if Input.is_action_pressed("ui_left"):
		$Camera2D.position.x -= delta * camera_speed * 20
	if Input.is_action_pressed("ui_right"):
		$Camera2D.position.x += delta * camera_speed * 20
	if Input.is_action_pressed("ui_up"):
		$Camera2D.position.y -= delta * camera_speed * 20
	if Input.is_action_pressed("ui_down"):
		$Camera2D.position.y += delta * camera_speed * 20
	if Input.is_action_just_pressed("music1"):
		$AudioSystem.setMusicLevel(1)
	if Input.is_action_just_pressed("music2"):
		$AudioSystem.setMusicLevel(2)
	if Input.is_action_just_pressed("music3"):
		$AudioSystem.setMusicLevel(3)
	if Input.is_action_just_pressed("music4"):
		$AudioSystem.setMusicLevel(4)
	if Input.is_action_just_pressed("ui_cancel"):
		exitToMenu()

func exitToMenu():
	set_visible(false)
	$AudioSystem.stopAll()

	for child in $CurrentGame.get_children():
		$CurrentGame.remove_child(child)
	$CanvasLayer/ColorRect.visible = false
	$Camera2D.smoothing_enabled = false
	$Camera2D.position = Vector2.ZERO
	#$Camera2D.smoothing_enabled = true
	emit_signal("game_over")


func _on_StartButton_pressed():
	$CanvasLayer/StartButton.visible = false
	$CanvasLayer/ResetButton.visible = true
	emit_signal("game_start")


func _on_ResetButton_pressed():
	$CPUParticles2D.visible = false
	$CanvasLayer/StartButton.visible = true
	$CanvasLayer/ResetButton.visible = false
	score = 0
	set_score_text()
	$AudioSystem.setMusicLevel(1)
	$AudioSystem.play()
	emit_signal("game_reset")

func set_visible(value : bool):
	.set_visible(value)
	visible = value
	for child in $CanvasLayer.get_children():
		child.set_visible(value)
	$CPUParticles2D.visible = false
	$CanvasLayer/Win.visible = false
	$CanvasLayer/TutorialPopup.visible = false
	#set_current_mode(current_mode)

func _on_NextButton_pressed():
	$CanvasLayer/Win.visible = false
	if next_level:
		loadLevel(next_level, false)
	else:
		score = 0
		exitToMenu()
