extends CenterContainer
class_name Crosshair

@onready var reticle: TextureRect = $Reticle
@onready var hitmarker: TextureRect = $Hitmarker


var default_scale: Vector2
var tween: Tween

func _ready() -> void:
	default_scale = scale


func tween_crosshair():
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_parallel(false)
	
	tween.tween_property(self, "scale", Vector2(0.75 , 0.75), 0.05)
	tween.tween_property(self, "scale", default_scale, 0.1)


func tween_hitmarker():
	hitmarker.modulate.a = 1.0
	#if tween:
		#tween.kill()
		
	tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(hitmarker, "modulate:a", 0.0, 0.15)
