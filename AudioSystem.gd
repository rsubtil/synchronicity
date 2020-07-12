extends Node

var max_files := 1

var queued := false
var level := 1

var play_values := []

func loadDynamicMusic(path : String, _max_files : int):
	max_files = _max_files
	for i in range(1, max_files + 1):
		play_values.append(false)
		get_node("AudioStreamPlayer" + str(i)).stream = load(path + str(i) + ".ogg")
	#setMusicLevel(1)

func play():
	$AudioStreamPlayer1.play()

func setMusicLevel(level : int):
	queued = true
	self.level = level
	for i in range(1, max_files + 1):
		play_values[i-1] = i <= level

func stopAll():
	for i in range(1, max_files + 1):
		play_values[i-1] = false
		get_node("AudioStreamPlayer" + str(i)).stop()

func _on_AudioStreamPlayer1_finished():
	if play_values[0]:
		$AudioStreamPlayer1.play()
		if queued:
			for i in range(2, max_files + 1):
				if i <= level:
					get_node("AudioStreamPlayer" + str(i)).play()
				else:
					get_node("AudioStreamPlayer" + str(i)).stop()
			queued = false

func _on_AudioStreamPlayer2_finished():
	if play_values[1]:
		$AudioStreamPlayer2.play()

func _on_AudioStreamPlayer3_finished():
	if play_values[2]:
		$AudioStreamPlayer3.play()

func _on_AudioStreamPlayer4_finished():
	if play_values[3]:
		$AudioStreamPlayer4.play()
