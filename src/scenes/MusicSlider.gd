extends HSlider

onready var base_volume = AudioServer.get_bus_volume_db(1)

func _on_MusicSlider_value_changed(value):
	var val = base_volume / clamp(value / 100, 0.01, 1)
	AudioServer.set_bus_volume_db(1, val)
