extends Node


func play_sound_3d(pos: Vector3, stream: AudioStream, spread: float = 10.0):
	var new_3d_audio = AudioStreamPlayer3D.new()
	get_tree().get_root().add_child(new_3d_audio)
	
	new_3d_audio.set_bus("SFX")
	new_3d_audio.global_position = pos
	new_3d_audio.stream = stream
	new_3d_audio.unit_size = spread
	new_3d_audio.finished.connect(new_3d_audio.queue_free)
	
	new_3d_audio.play()
