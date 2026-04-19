extends Decal

var tween: Tween

func _ready() -> void:
	$GPUParticles3D.emitting = true
	#$GPUParticles3D2.emitting = true
	await get_tree().create_timer(5.0).timeout
	fade_out()
	

func fade_out():
	tween = create_tween()
	
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_parallel(false)
	tween.tween_property(self, "modulate:a", 0.0, 5.0)
	tween.tween_callback(queue_free)
