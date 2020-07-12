tool
extends Node2D

enum State {
	PASS,
	STOP,
}

var pass_color = Color.limegreen
var stop_color = Color.red

var stopped_entities = []

export(String) var blocked_entity
export(State) var current_state setget set_state

# Called when the node enters the scene tree for the first time.
func _ready():
	set_state(current_state)

func set_state(state):
	current_state = state
	match current_state:
		State.PASS:
			$Line2D.default_color = pass_color
			for entity in stopped_entities:
				entity.semaphore_pass()
			stopped_entities.clear()
		State.STOP:
			$Line2D.default_color = stop_color


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var state = State.PASS if current_state == State.STOP else State.STOP
			set_state(state);

func _on_StopArea_area_entered(area):
	if area.is_in_group(blocked_entity):
		if current_state == State.STOP:
			stopped_entities.append(area);
			area.semaphore_stop()
