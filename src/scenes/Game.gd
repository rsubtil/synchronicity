extends Node2D

signal game_start
signal game_reset
signal game_lost
signal game_over

enum Mode {
	CONTROL,
	SIMULATION,
}

var current_mode = Mode.CONTROL setget set_current_mode

var score := 0 setget set_score
var target_score := 0

export(float, 1, 25) var camera_speed

func set_score(_score):
	score = _score
	if score >= target_score:
		print("You win!")

func game_over(position : Vector2):
	$CanvasLayer/CPUParticles2D.position = position
	$CanvasLayer/CPUParticles2D.visible = true
	emit_signal("game_lost")

func _ready():
	set_process(false)

func set_current_mode(_current_mode):
	current_mode = _current_mode
	match current_mode:
		Mode.CONTROL:
			$CanvasLayer/ControlMode.visible = true
			$CanvasLayer/SimulationMode.visible = false
		Mode.SIMULATION:
			$CanvasLayer/ControlMode.visible = false
			$CanvasLayer/SimulationMode.visible = true

func loadLevel(level : String):
	$Camera2D.smoothing_enabled = true
	visible = true
	var level_scene = load(level).instance()
	for child in $CurrentGame.get_children():
		$CurrentGame.remove_child(child)
	
	$CurrentGame.add_child(level_scene)
	target_score = level_scene.target_score
	$CanvasLayer/StartButton.visible = true
	$CanvasLayer/ResetButton.visible = false

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
	if Input.is_action_just_pressed("ui_cancel"):
		exitToMenu()

func exitToMenu():
	visible = false
	for child in $CanvasLayer.get_children():
		child.visible = false

	$Camera2D.smoothing_enabled = false
	$Camera2D.position = Vector2.ZERO
	#$Camera2D.smoothing_enabled = true
	emit_signal("game_over")


func _on_StartButton_pressed():
	$CanvasLayer/StartButton.visible = false
	$CanvasLayer/ResetButton.visible = true
	emit_signal("game_start")


func _on_ResetButton_pressed():
	$CanvasLayer/CPUParticles2D.visible = false
	$CanvasLayer/StartButton.visible = true
	$CanvasLayer/ResetButton.visible = false
	emit_signal("game_reset")
