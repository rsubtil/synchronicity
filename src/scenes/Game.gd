extends Node2D

signal game_over

enum Mode {
	CONTROL,
	SIMULATION,
}

var current_mode = Mode.CONTROL setget set_current_mode

export(float, 1, 25) var camera_speed

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

func _process(delta):
	handle_input(delta)
	match current_mode:
		Mode.CONTROL:
			$CanvasLayer/ControlMode.tick(delta)
		Mode.SIMULATION:
			$CanvasLayer/SimulationMode.tick(delta)
	
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
	$Camera2D.smoothing_enabled = false
	$Camera2D.position = Vector2.ZERO
	#$Camera2D.smoothing_enabled = true
	emit_signal("game_over")
