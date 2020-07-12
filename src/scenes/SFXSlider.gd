extends HSlider

onready var base_volume = AudioServer.get_bus_volume_db(2)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_SFXSlider_value_changed(value):
	var val = base_volume / clamp(value / 100, 0.01, 1)
	AudioServer.set_bus_volume_db(2, val)
	#$AudioStreamPlayer.stop()
	if !$AudioStreamPlayer.playing:
		$AudioStreamPlayer.play()
